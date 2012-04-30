require 'spec_helper'

describe Notification do
  let(:comment_notification) { create(:comment_notification) }
  let(:mention_notification) { create(:mention_notification) }
  
  it 'should has factories' do
    comment_notification.should be
    mention_notification.should be
  end
  
  describe 'Notification::Comment#message' do
    let(:post)    { create(:post ) }
    let(:comment) { create(:comment, post: post) }
    let(:user)    { create(:user) }
    
    subject do
      create(:comment_notification, { notifiable: comment, user: user })
    end
    
    its(:message) do
      user = comment.user
      link_to_user = %{<a href="/users/#{user.username}">#{user}</a>}
      link_to_post = %{<a href="/posts/#{post.id}#comment-#{comment.id}">post #{post.id}</a>}
      should == "#{link_to_user} wrote a comment in #{link_to_post}"
    end
  end
  
  describe 'Notification::Mention#message' do
    context 'in comment' do
      let(:post)    { create(:post ) }
      let(:comment) { create(:comment, post: post) }
      let(:user)    { create(:user) }
      
      subject do
        create(:mention_notification, { notifiable: comment, user: user })
      end
      
      its(:message) do
        user = comment.user
        link_to_user = %{<a href="/users/#{user.username}">#{user}</a>}
        link_to_post = %{<a href="/posts/#{post.id}#comment-#{comment.id}">post #{post.id}</a>}
        should == "#{link_to_user} mentioned you in comment to #{link_to_post}"
      end
    end
    
    context 'in post' do
      let(:post)    { create(:post ) }
      let(:comment) { create(:comment, post: post) }
      let(:user)    { create(:user) }
      
      subject do
        create(:mention_notification, { notifiable: post, user: user })
      end
      
      its(:message) do
        user = post.user
        link_to_user = %{<a href="/users/#{user.username}">#{user}</a>}
        link_to_post = %{<a href="/posts/#{post.id}">post #{post.id}</a>}
        should == "#{link_to_user} mentioned you in #{link_to_post}"
      end
    end
  end
end
