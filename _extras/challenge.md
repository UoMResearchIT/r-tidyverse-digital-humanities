---
layout: page 
title: Challenges and Discussion
permalink: /challenge/
---
<script>
  window.onload = function() {
    var lesson_episodes = [
    {% for episode in site.episodes %}
    "{{ episode.url}}"{% unless forloop.last %},{% endunless %}
    {% endfor %}
    ];
    var xmlHttp = [];  /* Required since we are going to query every episode. */
    for (i=0; i < lesson_episodes.length; i++) {
      xmlHttp[i] = new XMLHttpRequest();
      xmlHttp[i].episode = lesson_episodes[i];  /* To enable use this later. */
      xmlHttp[i].onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        var article_here = document.getElementById(this.episode);
        var parser = new DOMParser();
        var htmlDoc = parser.parseFromString(this.responseText,"text/html");
        var htmlDocBlockquote = htmlDoc.getElementsByClassName("challenge");
	      for(j=0; j < htmlDocBlockquote.length; j++) {
		      article_here.innerHTML += htmlDocBlockquote[j].outerHTML;
        	}
        }
      }
      episode_url = "{{ page.root }}" + lesson_episodes[i];
      xmlHttp[i].open("GET", episode_url);
      xmlHttp[i].send(null);
    }
    /* Call the code to fold the solutions away */
    var element = document.createElement("script");
    element.src = "../assets/js/jquery.min.js";
    document.body.appendChild(element);
    var element = document.createElement("script");
    element.src = "../assets/js/lesson.js";
    document.body.appendChild(element);
  }
</script>
{% comment %}
Create anchor for each one of the episodes.
{% endcomment %}
{% for episode in site.episodes %}
<h2>{{ episode.title}}</h2>
<article id="{{ episode.url }}"></article>
{% endfor %}

