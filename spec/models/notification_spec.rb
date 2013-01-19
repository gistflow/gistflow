require 'spec_helper'

def host
  Rails.application.config.host
end

describe Notification do
  let(:comment_notification) { create(:comment_notification) }
  let(:mention_notification) { create(:mention_notification) }
  let(:following_notification) { create(:following_notification) }
  
  it 'should has factories' do
    comment_notification.should be
    mention_notification.should be
    following_notification.should be
  end
  
  describe 'Notification::Comment' do
    let(:post)    { create(:post) }
    let(:comment) { create(:comment, post: post) }
    let(:user)    { create(:user) }
    
    subject do
      create(:comment_notification, { notifiable: comment, user: user })
    end
    
    its(:target_url) { should == "#{host}/posts/#{post.id}" }
    
    its(:message) do
      user = comment.user
      link_to_user = %{<a href="#{host}/users/#{user.username}">#{user}</a>}
      link_to_post = %{<a href="#{host}/posts/#{post.id}#comment-#{comment.id}" data-title="#{post.title}" class="notification_link">post #{post.id}</a>}
      should == "#{link_to_user} wrote a comment in #{link_to_post}"
    end
  end
  
  describe 'Notification::Following' do
    subject { following_notification }
    
    its(:target_url) { should == "#{host}/users/#{following_notification.notifiable.follower}" }
    
    its(:message) do
      user = following_notification.notifiable.follower
      link_to_user = %{<a href="#{host}/users/#{user.username}">#{user}</a>}
      message = "#{link_to_user} started following you."
      should == message
    end
  end
  
  describe 'Notification::Mention' do
    context 'in comment' do
      let(:post)    { create(:post ) } 
      let(:comment) { create(:comment, post: post) }
      let(:user)    { create(:user) }
      
      subject do
        create(:mention_notification, { notifiable: comment, user: user })
      end
      
      its(:target_url) { should == "#{host}/posts/#{post.id}" }
      
      its(:message) do
        user = comment.user
        link_to_user = %{<a href="#{host}/users/#{user.username}">#{user}</a>}
        link_to_post = %{<a href="#{host}/posts/#{post.id}#comment-#{comment.id}" data-title="#{post.title}" class="notification_link">post #{post.id}</a>}
        should == "#{link_to_user} mentioned you in comment to #{link_to_post}"
      end

      context 'when mention user in new comment' do
        let(:author) { post.user }
        let(:mention) { author.notifications.first }
        let!(:comment) { create :comment, content: "#{Faker::Lorem.sentence} @#{author.username}", post: post }

        it 'creates only mention notification' do
          author.notifications.should have(1).items
          mention.should be_kind_of(Notification::Mention)
          mention.notifiable.should eq(comment)
        end
      end
    end
    
    context 'in post' do
      let(:post)    { create(:post ) }
      let(:comment) { create(:comment, post: post) }
      let(:user)    { create(:user) }
      
      subject do
        create(:mention_notification, { notifiable: post, user: user })
      end
      
      its(:target_url) { should == "#{host}/posts/#{post.id}" }
      
      its(:message) do
        user = post.user
        link_to_user = %{<a href="#{host}/users/#{user.username}">#{user}</a>}
        link_to_post = %{<a href="#{host}/posts/#{post.id}" data-title="#{post.title}" class="notification_link">post #{post.id}</a>}
        should == "#{link_to_user} mentioned you in #{link_to_post}"
      end
    end
  end
end
