Zooniverse-readymade is a library that builds basic Zooniverse projects out of a fairly straightforward configuration. The `zooniverse-readymade` command initializes, serves, and builds those projects.

Getting started
===============

Install the library and its executable:

```sh
npm install zooniverse-readymade
```

Initialize a new project (in the current directory):

```sh
zooniverse-readymade init
```

Start a server to see if it's working. You can pass CSS and Stylus files in with the `--css` option.

**Note**: Files passed in with `--css` are stuck at the _top_ of the resulting CSS, before any of the Readymade-provided CSS. This sucks, but there's a "readymade" ID on the root element. Because none of the Readymade CSS is selected by ID, prefixing your CSS selectors with `#readymade` will override it. In Stylus, that means just start your file with `#readymade` and indent everything a level under it. I'm looking for a fix for this.

You can also pass in additional JavaScript and CoffeeScript files with `--js`. You can access the current project by requiring `zooniverse-readymade/current-project`.

```sh
zooniverse-readymade serve --css project.styl
open http://localhost:2005/index.html
```

Now edit the configuration in `project.coffee` and the css in `project.styl`. Configuration options are detailed below.

Build when you're ready. Deploy however.

```sh
zooniverse-readymade build --css project.styl
```

Project configuration
=====================

Most things are optional. HTML can be used where it makes sense.

`id`: The ID of the project on the back end. Required. _TODO: What if the project is self-hosted?_

`background`: A URL of the site's background image.

Home page
---------

`producer`: The name of the main group responsible for building the project?

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

### Multiple workflows

If you need more than one type of classification, instead of defining `tasks` and `firstTask`, define a `workflows` array. Each workflow needs `key` (arbitrary, but machine-friendly) and `label` (used as the link the the page instead of "Classify") strings in addition to `tasks` and `firstTask`.

Misc. pages
-----------

`pages`: Any additional pages you want to include can be defined here as an array of maps. Keys will be the page titles (and URLs), values will be page content (as HTML).

Team page
---------

`organizations`: An array of member organziations.

`scientists`: An array of member scientists.

`developers`: An array of member developers.

Member properties are `image`, `name`, `location`, `description`, and `url`; all optional.

Creating new tasks
==================

**See `zooniverse-decision-tree/src/radio-task.coffee` for a task example.**

Tasks extend the `Task` class from the `zooniverse-decision-tree` module. a `DecisionTree` is responsible for loading up the right task. Each task needs:

`choiceTemplate(choice, i)`: Returns a string of HTML for each choice in the task. Usually a button or an input, plus whatever is needed to separate and style things how you want 'em.

`enter()`: Called when the task is loaded. Attach any needed event listeners.

`exit()`: Called when the task is unloaded. Detach those event listeners, clean up whatever.

`getValue()`: Returns the current value of the task.

`reset(value)`: Reset the task's value and rendering, adopting any value passed in.

Creating new drawing tools
==========================

** See `marking-surface/src/tools/point.coffee` for a drawing tool example.**

Drawing tools extend the `Tool` class from the `marking-surface` module.

An instance of `Tool` is associated with an instance of `Mark`. As the user interacts with the tool, the mark should change. As the mark changes, the display of the tool should update.

`constructor`: Extend the constructor to set up the shapes used by your tool. Add shapes with the `addShape(type, attributes)` method. Add events with the `addEvent(eventName, selector, handler)` method.

`rescale(scale)`: When the marking surface is resized, this is called for each tool with the current scale of the marking surface. Set the size of your shapes here.

`onInitialStart`, `onInitialMove`, `onInitialRelease`: These are called during the marking surface's initial create-a-tool-from-nothing cycle. These will generally delegate to a more specific event handler.

`render`: Update the rendering of the tool to match its mark.

Extending behavior
==================

TODOC: Events

Using components individually
=============================

The components that make up the whole Readymade thing can be used in other projects.

Classifier
----------

Handles the lower level classification stuff. It'll fetch new subjects when appropriate. Define a `loadSubject` method to establish what happens when a subject is loaded.

If a `tutorial` property is defined, it'll load and start a tutorial when appropriate. Define `startTutorial` to set this up.

Override the `loadClassification` method to tell it how to render itself with a pre-existing classification. This is still in progress, but at asome point it'll save the current subject and classification in localStorage so the user can pick up where they left off.

ClassifyPage
------------

The `ClassifyPage` extends `Classifier`, displaying subjects in a `SubjectViewer` and getting other classification workflow information from a `DecisionTree`

SubjectViewer
-------------

`SubjectViewer` displays a subject's image(s) in a `MarkingSurface` (brian-c/marking-surface on GitHub), annotating marks when the current workflow task is some kind of drawing task.

DecisionTree
------------

This is a separate module, zooniverse/zooniverse-decision-tree on GitHub. It takes a linked list of tasks and lets you step through them.
