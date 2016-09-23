translate = window.zooniverse?.translate or require('zooniverse/lib/translate')

module.exports = -> "
  #{ translate('p','readymade.thankYou') }

  <div>
    <p>
      #{ translate('readymade.talkQuestion') }
      <span class='readymade-existing-comments'>
        #{ translate('readymade.existingComments')}
      </span>
    </p>

    <p class='readymade-talk'>
      <button type='button' name='readymade-dont-talk'>#{ translate('readymade.no') }</button>
      <a href='#' class='readymade-talk-link'>#{ translate('readymade.yes') }</a>
    </p>
  </div>

    #{if location.href.indexOf('beta') is -1 then "
    <div>
      <p>
        #{ translate('readymade.share') }
      </p>

      <p class='readymade-social'>
        <a href='#' class='readymade-facebook-link'><i class='fa fa-facebook-square'></i></a>
        <a href='#' class='readymade-twitter-link'><i class='fa fa-twitter'></i></a>
      </p>
    </div>
  " else ''}
"
