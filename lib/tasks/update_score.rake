namespace :update_score do
  desc "Update link score"
  task "update_link_score" => :environment do
    logfile = "#{Rails.root}/log/scoring/link_score_#{DateTime.now.strftime('%Y%m%d_%H')}"
    comment_weight = 0.5
    point_aging_factor = 1
    age_padding = 3600*8
    File.open(logfile, "w") do |f|
      Link.all.each do |link|
        number_of_votes = Vote.count(:condition => "link_id = #{ link.id }")
        number_of_comments = LinkComment.count(:condition => "link_id = {{ link.id }}")
        point = number_of_votes + number_of_comments * comment_weight
        age = Time.now.to_i - link.created_at.to_i
        point = ((point.to_f*1000000)/((age + age_padding)**point_aging_factor))
        link.update_column(:point, point)
        f.write("Updated for link: #{link.id}'s point\n")
      end
    end
  end
end
