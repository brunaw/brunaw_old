---
title: "Develop Packages in `R` Workshop"
date: April, 2019
output:
  rmarkdown::html_vignette:
    fig_width: 5
    fig_height: 3.5
    fig_cap: TRUE
    toc: yes
    css: css/style.css
biblio-style: "apalike"
link-citations: yes
header-includes:
  - \usepackage{mathtools}
editor_options: 
  chunk_output_type: console
---

<style type="text/css">
#TOC {
  margin: 0 270px;
  width: 425px;
}
</style>
</style>
<div class="outer">
<img src="./logo.png"  width="120px" display="block" align="bottom">
</div>
<b>
<center>
<a href="https://www.meetup.com/pt-BR/R-Ladies-Dublin/?chapter_analytics_code=UA-102759102-1"> 
R-Ladies Dublin </a><br/>
</center>

</b>
</div>
</div>




# Data description

Music is something most people like. Because of that, we would like
to propose a very rich dataset, containing many features about songs.

The proposed data has 20 columns and 3014. The data is
about the songs of the band called [Muse](https://pt.wikipedia.org/wiki/Muse),
and the columns are described as follows: 

- "chord" = the music chords of the song, in sequence. 
- "key_song" = the music key of the song. 
- "song"  = the name of the song.             
- "name_artist" = the name of the artist.      
- "language" = the language in which the lyrics are.          
- "text" = the lyrics of the song.             
- "translation" = the translation (to portuguese) of the lyrics.      
- "danceability" = describes how suitable a track is for dancing based on a combination of musical elements including tempo, rhythm stability, beat strength, and overall regularity.     
- "energy" =  a measure from 0.0 to 1.0 and represents a perceptual measure of intensity and activity.            
- "key_spotify" = estimated overall key of the track. Integers map to
pitches using standard Pitch Class notation . E.g. 0 = C, 1 = C#/Db 
2 = D, and so on.           
- "loudness" = overall loudness of a track in decibels (dB).          
- "mode" = indicates the modality (major or minor) of a track, the 
type of scale from which its melodic content is derived.             
- "speechiness" = detects the presence of spoken words in a track.      
- "acousticness" = a measure from 0.0 to 1.0 of whether the track is 
acoustic.     
- "instrumentalness" = whether a track contains no vocals. 
- "liveness" = detects the presence of an audience in the recording.         
- "valence"  =  measure from 0.0 to 1.0 describing the musical positiveness conveyed by a track.       
- "tempo" = overall estimated tempo of a track in beats per minute (BPM).           
- "duration_ms" = duration of the track in milliseconds.       
- "time_signature" = the duration of the track in milliseconds.


To give a little bit more of context, we have the information about the
chords, lyrics and features extracted from the Spotify API about the
songs in question. Those variables were obtained with the help of
the packages:

  - [`chorrrds`](https://github.com/r-music/chorrrds)
  - [`vagalumeR`](https://github.com/r-music/vagalumeR)
  - [`RSpotify`](https://github.com/tiagomendesdantas/Rspotify)
  
If you would like to know more about those packages, please check
the [R-Music](https://r-music.rbind.io/) blog:

R-Music <img src="https://raw.githubusercontent.com/r-music/site/master/img/logo.png" style="float:left;margin-right:20px;" width=120>

<h4 style="padding:0px;margin:10px;">
R for music data extraction and analysis
</h4>

See the [R-Music](https://github.com/r-music) organization on GitHub for 
more `R` packages related to music data extraction and analysis. The [R-Music blog](https://r-music.rbind.io/) provides package introductions and examples.


The glimpse of the data is in the following. 


```r
library(tidyverse)
```



```r
df <- read.table("data/muse_data.txt")

glimpse(df)
```

```
## Observations: 3,014
## Variables: 20
## $ chord            <fct> F#m, E, Bm, D, A5, E, F#m, E, Bm, D, A5, E, F#m…
## $ key_song         <fct> A, A, A, A, A, A, A, A, A, A, A, A, A, A, A, A,…
## $ song             <fct> aftermath, aftermath, aftermath, aftermath, aft…
## $ name_artist      <fct> muse, muse, muse, muse, muse, muse, muse, muse,…
## $ language         <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
## $ text             <fct> War is all around  I'm growing tired of fightin…
## $ translation      <fct> [Aftermath] A guerra é tudo ao redor  Eu estou …
## $ danceability     <dbl> 0.295, 0.295, 0.295, 0.295, 0.295, 0.295, 0.295…
## $ energy           <dbl> 0.495, 0.495, 0.495, 0.495, 0.495, 0.495, 0.495…
## $ key_spotify      <int> 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9,…
## $ loudness         <dbl> -7.646, -7.646, -7.646, -7.646, -7.646, -7.646,…
## $ mode             <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
## $ speechiness      <dbl> 0.0316, 0.0316, 0.0316, 0.0316, 0.0316, 0.0316,…
## $ acousticness     <dbl> 0.215, 0.215, 0.215, 0.215, 0.215, 0.215, 0.215…
## $ instrumentalness <dbl> 0.0112, 0.0112, 0.0112, 0.0112, 0.0112, 0.0112,…
## $ liveness         <dbl> 0.122, 0.122, 0.122, 0.122, 0.122, 0.122, 0.122…
## $ valence          <dbl> 0.115, 0.115, 0.115, 0.115, 0.115, 0.115, 0.115…
## $ tempo            <dbl> 72.09, 72.09, 72.09, 72.09, 72.09, 72.09, 72.09…
## $ duration_ms      <int> 347997, 347997, 347997, 347997, 347997, 347997,…
## $ time_signature   <int> 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,…
```

```r
names(df)
```

```
##  [1] "chord"            "key_song"         "song"            
##  [4] "name_artist"      "language"         "text"            
##  [7] "translation"      "danceability"     "energy"          
## [10] "key_spotify"      "loudness"         "mode"            
## [13] "speechiness"      "acousticness"     "instrumentalness"
## [16] "liveness"         "valence"          "tempo"           
## [19] "duration_ms"      "time_signature"
```



Some analysis sugestions for this data are:

  - Sentiment analysis with the lyrics; 
  - Topic modelling of the lyrics; 
  - Finding frequent words or sentences in the lyrics;
  - Plotting the distributions of the Spotify variables;
  - Chord diagramas with the chords sequences;
  - Finding common chord transitions; 
