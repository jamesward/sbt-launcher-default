sbt launcher default
--------------------

[![Unix Build Status](https://travis-ci.org/jamesward/sbt-launcher-default.svg?branch=master)](https://travis-ci.org/jamesward/sbt-launcher-default)
[![Windows Build Status](https://ci.appveyor.com/api/projects/status/i8ejry32pout17nd?svg=true)](https://ci.appveyor.com/project/jamesward/sbt-launcher-default)

An sbt launcher that supports running a default task.  If you just run `./sbt` or double click on the script from a file explorer, this launcher will try to run an sbt task named `default`.  To get into the sbt shell run `./sbt shell` or somehow add a `default` task to your build that runs the shell (if that is possible).