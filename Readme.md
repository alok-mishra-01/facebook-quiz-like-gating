Facebook Quiz with like gating
===============================

Alok Mishra
June 2013

Languages:
PHP, Flash/AS3, Facebook API


This is a working version of a facebook quiz integrated with MySQL backend.
Quizes like this are high in demand for social media marketing these days.

Anyone having a similar requirement should look no further and can just use this project.
It can be modified and used for any other app which needs like gating.

I have removed all the client pages, urls and pictures and replaced them with placeholders. You can just replace them with your own.

I did it for a client who wanted:
- A quiz on his facebook page
- A player can play only if he 'likes' the page
- Integrated with the latest facebook PHP API. Also has the facility to post on his wall from flash too.
- Rich graphics, hence flash was used. It also stores and displays the high scores of players
  with a complete dynamic leaderboard at the end of the quiz.
- Using the time to answer, which is in milliseconds, the admin can declare winners every week or everyday.

How to use
-----------
In its current state, I have put dummy app_ids and urls. So lets edit all that to get started.

1. First all copy files inside Server/ to your web root.

2. Create a database called 'quiz' and import player_info.sql into that.

3. Open web root/config.php and edit the relevant details like database, facebook urls etc.
   IMP: You need to first create a facebook app and link it to a page first, to enter these details.

4. Open Flash Frontend/GameConfig.as and edit the question answers you want and the path to db.php and db2.php on your server.
   Then edit Flash Frontend/Quiz.as and put the url for web root/Pics.swf in there.

5. Compile Quiz.fla( Pics.fla is already compiled for you). The resulting Quiz.swf has to be copied to the web root folder to replace the file there.

6. In your facebook application. Put the app url to point to index.php in your server.

Thats it! Enjoy this application for free. But make money from it, like I did :)