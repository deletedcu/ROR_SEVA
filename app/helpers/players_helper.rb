module PlayersHelper
  def embed_youtube_player_url(url)
    # YouTube iframes expect urls in this format: https://www.youtube.com/embed/youtube_id
    # adapted from http://stackoverflow.com/questions/6556559/youtube-api-extract-video-id:
    player_match = url.to_s.match(/youtube.com.*(?:\/|v=)([^&$]+)/)
    if player_match
      video_guid = player_match[1]
      url = 'https://www.youtube.com/embed/'+video_guid
    end
    url
  end

  def seva_score_color(seva_score)
    if seva_score >= 8.0
      return "blue"
    end
  end

end
