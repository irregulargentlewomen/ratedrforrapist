About
=====
Rated R For Rapist provides information about whether a movie has been made in part by people who have chosen to collaborate with or otherwise support Roman Polanski.

The interested user may wish to read any or all of the following texts related to <em>People of the State of California v. Roman Raymond Polanski</em> and the ramifications thereof:
* [1977 grand jury testimony transcript](http://www.thesmokinggun.com/file/roman-polanski-grand-jury-transcript)
* [What's "Unlawful Sexual Intercourse"?](http://www.slate.com/articles/news_and_politics/explainer/2009/09/whats_unlawful_sexual_intercourse.single.html), by Brian Palmer
* [Reminder: Roman Polanski raped a child](http://www.salon.com/2009/09/28/polanski_arrest/), by Kate Harding
* [Six Degrees of Roman Polanski](http://mommyish.com/stuff/six-degrees-of-roman-polanski-361/), by Eve Vawter

Installation
============
This is a Sinatra project, and we run Sequel for the ORM against MySQL.

Copyright and licensing
=======================
Rated R For Rapist is a project of the [Irregular Gentlewomen](https://github.com/irregulargentlewomen): [Betsy Haibel](http://bhaibel.github.com) and [Elizabeth Yalkut](http://www.elizabethyalkut.com). It is released under the [GPL](http://www.gnu.org/licenses/gpl-3.0.en.html). The code is [available on Github](https://github.com/irregulargentlewomen/polanski).

Credits
=======
Tools used in creating this app include:
* [Font Awesome](http://fortawesome.github.com/Font-Awesome/), which is licensed under [CC BY 3.0](
http://creativecommons.org/licenses/by/3.0/)
* [320 and Up](http://stuffandnonsense.co.uk/projects/320andup/), which is licensed under [Apache 2.0](http://www.apache.org/licenses/)

The capsule biography of Roman Polanski is adapted from the New Oxford American Dictionary.

[A Vague Disclaimer Is Nobody's Friend](http://tmblr.co/Z-dllxbNAKMv)
=====================================
While the Irregular Gentlewomen make no claim to complete accuracy in the results provided by this tool, and acknowledge that both false positives and negatives may occur, we are committed to maintaining a dataset which is as accurate as possible. The information used in determining if a movie has been made in part by Roman Polanski collaborators or supporters is drawn from the following sources:
* [Bernard-Henri Levy](http://www.bernard-henri-levy.com/si-vous-souhaitez-signer-la-petition-pour-roman-polanski-2418.html)
* [The Independant](http://www.independent.co.uk/voices/commentators/harvey-weinstein-polanski-has-served-his-time-and-must-be-freed-1794699.html)
* [The Huffington Post](http://www.huffingtonpost.com/kim-morgan/roman-polanski-understand_b_301292.htm)
* [NPR](http://www.npr.org/templates/story/story.php?storyId=113316262)
* [New York Times](http://roomfordebate.blogs.nytimes.com/2009/09/29/the-polanski-uproar/#damon)
* [SACD](http://www.sacd.fr/Tous-les-signataires-de-la-petition-All-signing-parties.1341.0.html)
* [The Wrap](http://www.thewrap.com/article/hollywood-reacts-shock-polanski-arrest-7844)
* [YouTube][1](http://www.youtube.com/watch?v=yyx4E51ZCns), [2](http://www.youtube.com/watch?v=As7nJgSoWrg), [3](http://www.youtube.com/watch?v=nZskUvAGyjQ)

If you have a source for us to add to our list, or information indicating that one of our sources is out-of-date or otherwise inaccurate, we will be happy to update our dataset to reflect that; please email <irregulargentlewomen@gmail.com>.

All cast and crew information is sourced through The Movie Database's API. TMDB is an open dataset and corrections may be directly made there. Rated R for Rapist caches cast and crew data for movies which Roman Polanski worked on after 1977, though it does not cache other movie data retrieved from TMDB. This caching is a partially-manual process and we do not refresh this cache frequently as the data is largely static. If you make a change to TMDB data which affects this portion of our dataset, or notice a change which has made our cache out-of-date, please notify us so that we can run an update. This data was last checked in May 2013.

If you are a petitioner, supporter, or former collaborator who is uncomfortable with your name appearing in our dataset, our _removal policy_ is as follows:

Petitioners
-----------
Please withdraw your name from the petition(s) you've signed and send us documentation of this withdrawal. "Documentation" can be as simple as a link to an updated petition.

Other supporters
---------------
Our "other supporter" data is drawn from public statements. Please provide documentation of a later statement where you contradict your prior support, or documentation indicating that our sources misquote you.

Former collaborators
--------------------
We're uncomfortable with obscuring the historical record. The only former "collaborator" of Roman Polanski that our dataset generation script ignores is William Shakespeare, and we'll only consider removing/ignoring collaboration data under similar exceptional circumstances. However, if you provide documentation of a public statement which indicates that your past collaboration is not reflective of present support, we will add a clarifying annotation to our dataset.

Statement of Intent
===================
Roman Polanski has been working in the film industry, American and European, for decades. He is undeniably a talented filmmaker and therefore enjoys the support of many of his fellow filmmakers. Because we live in a society which excuses, minimizes, and avoids thinking about rape, he has been able to retain that support even though he is an admitted rapist.

We are not interested in debating, discussing, or engaging with the question of whether Polanski's life, history, and/or talent provide mitigating circumstances; this project operates on the assumptions that (a) drugging and raping a thirteen-year-old is not an excusable action, (b) to attempt to excuse such an action allies one with the rapist rather than the survivor, and (c) to choose not to support, financially or otherwise, the work of a rapist or those who support a rapist is an ethical action. Many people have independently made such a choice; this tool is meant only to provide information to make it easier to follow through on that choice.

These are our premises; we do not intend to defend or explain them beyond this statement. 

&mdash; Elizabeth Yalkut and Betsy Haibel, September 2013

To Do (in no order whatsoever)
==============================
* test the CSS on iphone
* fix the portrait - > landscape crash on Android
* migrate CSS to scss
* add documentation comments to CSS and HTML
* refine language in further-info alert
* add cron job to email reminder to update/disambiguate blacklist
* establish baseline blacklist from script and disambiguate as needed
* once the script is run through, live testing of form submission
* add annotations to provide context for why person(s) trigger link to Polanski
* add pushstate/permalinks
* prettify movie disambiguation, results list, close icon on responses