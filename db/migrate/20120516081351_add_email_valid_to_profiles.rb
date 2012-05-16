class AddEmailValidToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :email_valid, :boolean, :default => false
    
    Profile.all.each do |profile|
      if profile.email =~ Profile::EMAIL_FORMAT
        profile.update_attribute(:email_valid, true) 
      end
    end
  end  
end