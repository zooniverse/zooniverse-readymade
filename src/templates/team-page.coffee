module.exports = (context) ->
  template = -> "
    <div class='readymade-team-page'>
      #{(for group in ['organizations', 'scientists', 'developers'] when @[group]? then "
        <div class='readymade-team-group-title'>
          #{if group is 'organizations' then "
            Organizations
          " else if group is 'scientists' then "
            Scientists
          " else if group is 'developers' then "
            Developers
          " else ''}
        </div>

        <div class='readymade-#{group} readymade-team-group'>
          #{(for member, i in @[group] then "
            <div class='readymade-team-member'>
              #{if member.image? then "
                <img src='#{member.image}' class='readymade-team-member-photo' />
              " else ''}

              <div class='readymade-team-member-title'>
                #{if member.name? then "
                  #{member.name}
                " else ''}

                #{if member.url? then "
                  <span class='readymade-member-links'>
                    #{(for url in [].concat member.url then "
                      <a href='#{url}' class='readymade-member-url'>
                        <!--TODO: These will be icons.-->
                        #{if url.match 'facebook.com' then "
                          <i class='fa fa-lg fa-facebook-square'></i>
                        " else if url.match 'github.com' then "
                          <i class='fa fa-lg fa-github-alt'></i>
                        " else if url.match 'linkedin.com' then "
                          <i class='fa fa-lg fa-linkedin-square'></i>
                        " else if url.match 'twitter.com' then "
                          <i class='fa fa-lg fa-twitter'></i>
                        " else if url.match 'mailto:' then "
                          <i class='fa fa-lg fa-envelope'></i>
                        " else "
                          <i class='fa fa-lg fa-globe'></i>
                        "}
                      </a>
                    ").join '\n'}
                  </span>
                " else ''}
              </div>

              <div class='readymade-team-member-description'>
                #{if member.description? then "
                  #{member.description}
                " else ''}
              </div>
            </div>

            <!--#{(for grouping in [2...5] when (i + 1) % grouping is 0 then "
              <span class='readymade-set-of-#{grouping}'></span>
            ").join '\n'}-->
          ").join '\n'}
        </div>
      ").join '\n'}
    </div>
  "
  template.call context
