(function() {
  var browserSync, browserify, gulp, jade, less, path, react, reactify, source, watchify;

  path = require('path');

  gulp = require('gulp');

  browserSync = require('browser-sync');

  browserify = require('browserify');

  watchify = require('watchify');

  reactify = require('reactify');

  source = require('vinyl-source-stream');

  jade = require('gulp-jade');

  less = require('gulp-less');

  react = require('gulp-react');

  gulp.task("browser-sync", function() {
    browserSync.init("public/**", {
      server: {
        baseDir: "public"
      },
      injectChanges: false,
      logConnections: true,
      ghostMode: {
        clicks: true,
        scroll: true,
        location: true
      }
    });
  });

  gulp.task("templates", function() {
    var data;
    data = {
      title: 'Fancy Title!'
    };
    gulp.src("templates/*.jade").pipe(jade({
      locals: data
    })).pipe(gulp.dest("./public/"));
  });

  gulp.task('styles', function() {
    gulp.src("styles/*.less").pipe(less({
      paths: [path.join(__dirname, "less", "includes")]
    })).pipe(gulp.dest("./public"));
  });

  gulp.task('compile', function() {
    var bundle, w;
    w = watchify(browserify('./app/index.js', watchify.args));
    bundle = function() {
      return w.bundle().pipe(source('script.js')).pipe(gulp.dest('./public/'));
    };
    w.on('update', bundle);
    bundle();
  });

  gulp.task("default", ['compile', 'styles', 'templates', 'browser-sync'], function() {
    gulp.watch("templates/*.jade", ["templates"]);
    gulp.watch("styles/*.less", ["styles"]);
    gulp.watch('js/**', ['copy']);
  });

}).call(this);
