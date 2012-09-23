namespace :time_counters do
  task create: :environment do    
    TimeCounter::MODELS.each do |model_name|
      klass = model_name.to_s.classify.constantize

      # TODO group by date, not by datetime (keys are the same dates for today_count)
      klass.select(:created_at).order('created_at DESC').
        group_by(&:created_at).
        each_pair do |date, records|
          TimeCounter.create(
            :date => date.to_date,
            :model => model_name,
            :today_count => records.count,
            :total_count => klass.where('created_at <= ?', date).count
          )    
        end
    end
  end

  task generate_todays: :environment do
    today_date = Date.today
    TimeCounter::MODELS.each do |model_name|
      klass = model_name.to_s.classify.constantize

      TimeCounter.create(
        :date => today_date,
        :model => model_name,
        :total_count => klass.count,
        :today_count => klass.where(
          'DATE(created_at) = DATE(?)', 
          Time.now
        ).count
      )
    end
  end
end