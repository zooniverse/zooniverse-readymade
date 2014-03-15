Zooniverse-readymade is a library that builds basic Zooniverse projects out of a fairly straightforward configuration. The `zooniverse-readymade` command serves and build those projects.

```sh
npm install zooniverse-readymade              # Install
zooniverse-readymade init                     # Generate a project template
subl ./project.{coffee,styl}                  # Edit the configuration and style
zooniverse-readymade serve --css project.styl # Run the server
open http://localhost:2005/index.html         # Open in your broweser
zooniverse-readymade build --css project.styl # Build the static app
```

Project configuration
=====================

Most things are optional. HTML can be used where it makes sense.

General
-------

`id`: The ID of the project on the back end. Required. _TODO: What if the project is self-hosted?_

`background`: A URL of the site's background image.

Home page
---------

`producer`: The name of the main group reponsible for building the project?

`title`: A catchy name for the project. Just don't call it "#{topic} Zoo"; that's lazy.

`summary`: The headline on the home page.

`description`: The rest of the content on the home page.

Classify page
-------------

The _Classify_ page is defined by `tasks`. Each task asks a question and provides the user with choices. In the case of a `drawing` task, the choices are tools the user can use to draw on the subject image. These drawings are then included in the "answer" to the task.

`tasks`: A map of task keys to tasks. The key will be used to identify a task in the raw data produced by the project.

`firstTask`: The task to start with, if there are multiple tasks.

### Tasks

`type`: Current types are `radio`, `checkbox`, `button`, and `drawing`.

`next`: The key of the task to show after this task is completed.

New tasks can be defined by extending the `Task` class in the `zooniverse-decision-tree` module.

### Choices

`value`: The value to be recorded in the data.

`image`, `label`: These define the button the user will click to activate this choice.

`color`: A CSS color value. Adds a swatch of color to the button. In the case of a `drawing` task, this is also the color of the drawing itself.

`details`: An array of sub-tasks for the user to fill out for each drawing made. Keep it brief. Only for `drawing` task choices.

`next`: In `radio` and `button` tasks, override the task's `next` depending on what was chosen.

### Drawing details

Details take the same properties as tasks. Because they're shown at once instead of in series, they're defined in an array, which means they need their `key` property set manually.

About page
----------

`about`: HTML content for the _About_ page.

Additional pages
----------------

`pages`: Any additional pages you want to include can be defined here as an array of maps. Keys will be the page titles (and URLs), values will be page content (as HTML).

Team page
---------

`organizations`: An array of member organziations.

`scientists`: An array of member scientists.

`developers`: An array of member developers.

Member properties are `image`, `name`, `location`, `description`, and `url`, all optional.
