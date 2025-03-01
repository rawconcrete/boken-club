# app/helpers/adventures_helper.rb
module AdventuresHelper
  # Generate adventure tags based on the adventure name
  def adventure_tags(adventure)
    tags = []

    # Base tags on adventure name
    name = adventure.name.downcase

    # Activity level
    if name.match?(/hiking|trekking|climbing|trail running|mountaineering/)
      tags << tag_pill('Active', 'danger')
    elsif name.match?(/camping|star gazing|castle touring/)
      tags << tag_pill('Relaxed', 'info')
    end

    # Skill level
    if name.match?(/mountaineering|rock climbing|ski.*backcountry/)
      tags << tag_pill('Advanced', 'warning')
    elsif name.match?(/bouldering|trail running|kayaking|snowboarding/)
      tags << tag_pill('Intermediate', 'primary')
    else
      tags << tag_pill('Beginner-friendly', 'success')
    end

    # Duration
    if name.match?(/trekking|mountaineering/)
      tags << tag_pill('Multi-day', 'secondary')
    else
      tags << tag_pill('Day trip', 'light')
    end

    # Season
    if name.match?(/ski|snowboard|snowshoe/)
      tags << tag_pill('Winter', 'info')
    elsif name.match?(/kayak|raft|swim/)
      tags << tag_pill('Summer', 'warning')
    end

    # Environment
    if name.match?(/hik|trek|trail|mountain/)
      tags << tag_pill('Mountains', 'success')
    elsif name.match?(/kayak|raft|fish/)
      tags << tag_pill('Water', 'primary')
    elsif name.match?(/camp/)
      tags << tag_pill('Outdoors', 'secondary')
    elsif name.match?(/castl|tour/)
      tags << tag_pill('Cultural', 'info')
    end

    tags.join.html_safe
  end

  private

  def tag_pill(text, style)
    "<span class='badge bg-#{style} me-1 mb-1'>#{text}</span>"
  end
end
