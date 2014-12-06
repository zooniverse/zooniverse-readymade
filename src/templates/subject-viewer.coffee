translate = require 'zooniverse/lib/translate'

module.exports = -> """
  <div class="drawing-controls">
    <label class="readymade-has-clickable">
      <input type="checkbox" name="favorite" />
      <span class="readymade-clickable">
        <i class="fa fa-heart-o readymade-clickable-not-checked"></i>
        <i class="fa fa-heart readymade-clickable-checked" style="color: orangered;"></i>
        <span>#{translate 'readymade.favorite'}</span>
      </span>
    </label>

    <label class="readymade-has-clickable">
      <input type="checkbox" name="hide-old-marks" />
      <span class="readymade-clickable">
        <i class="fa fa-eye-slash readymade-clickable-not-checked"></i>
        <i class="fa fa-eye-slash readymade-clickable-checked" style="color: orangered;"></i>
        <span>#{translate 'readymade.hideOldMarks'}</span>
      </span>
    </label>

    <button name="restart-tutorial">
      <span class="readymade-clickable">
        <i class="fa fa-graduation-cap"></i>
        <span>#{translate 'readymade.restartTutorial'}</span>
      </span>
    </button>
  </div>

  <div class="readymade-marking-surface-container"></div>

  <div class="readymade-frame-controls">
    <div class="readymade-frame-play-controls">
      <button name="play-frames">►</button>
      <button name="pause-frames">◼</button>
    </div>

    <div class="readymade-frame-toggles-list"></div>
  </div>
"""
