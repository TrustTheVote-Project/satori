exports.config =
  files:
    javascripts:
      joinTo:
        'javascripts/lib.js': /vendor/
        'javascripts/app.js': /app/
      order:
        before: [
          'vendor/brunch/javascripts/jquery.dataTables.min.js',
          'vendor/brunch/javascripts/dataTables.fixedColumns.js'
        ]

    stylesheets:
      joinTo:
        'stylesheets/lib.css': /vendor/
        'stylesheets/app.css': /app/

  plugins:
    react:
      autoIncludeCommentBlock: yes
    # cleancss:
    #   keepSpecialComments: 0
    #   removeEmpty: true

  conventions:
    assets: /app\/brunch\/assets/

  modules:
    nameCleaner: (path) ->
      path
        # Strip the .cjsx extension from module names
        .replace(/\.cjsx/, '')

        # Replace extended component path with 'component'
        .replace('app/brunch/javascripts/components/', 'component/')

        # Cleanup general-purpose module name
        .replace('app/brunch/javascripts/', '')

  paths:
    watched: [ 'app/brunch', 'vendor/brunch' ]
