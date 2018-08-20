require 'test_helper'

class ChaptersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @chapter_one = chapters(:chapter_one)
    @chapter_two = chapters(:chapter_two)
    @room_one = rooms(:one_for_chapter_one)
    @room_two = rooms(:two_for_chapter_one)
  end
  
  test 'should be successful to open chapter list page' do
    get '/chapters'
    assert :success
  end

  test 'should be successful to open new chapter page' do
    get '/chapters/new'
    assert :success
  end

  test 'should be successful to create a new chapter' do
    post '/chapters', params: {chapter: {number: '9', rooms_count: '5', active: '1'}}
    assert_redirected_to assigns(:chapter)
  end
  
  test 'should be successful to open show page of a chapter' do
    get "/chapters/#{@chapter_one.id}"
    assert :success
  end
  
  test 'should be successful to open edit page of a chapter' do
    get "/chapters/#{@chapter_one.id}/edit"
    assert :success
  end

  test 'should be failed to update a chapter' do
    put "/chapters/#{@chapter_two.id}", params: {chapter: {number: '1', active: '1'}}
    @chapter_two.reload
    assert_equal false, @chapter_two.active
  end
  
  test 'should be successful to update a chapter' do
    put "/chapters/#{@chapter_one.id}", params: {chapter: {number: '1', active: '0'}}
    @chapter_one.reload
    assert :success
    assert_equal false, @chapter_one.active
    assert_redirected_to @chapter_one

    put "/chapters/#{@chapter_two.id}", params: {chapter: {number: '2', active: '1'}}
    @chapter_two.reload
    assert :success
    assert_equal true, @chapter_two.active
    assert_redirected_to @chapter_two
  end
  
  test 'should be successful to destroy a chapter' do
    delete "/chapters/#{@chapter_one.id}"
    assert :success
    assert_redirected_to chapters_url
  end
  
  test 'test maze' do
    get '/maze/room/1'
    assert :success
    assert_equal @room_one, assigns(:room)
    assert_equal [@room_two], assigns(:available_rooms)
    
    get "/maze/room/#{@room_two.id}?chapter_id=#{@chapter_one.id}"
    assert :success
    assert_equal @room_two, assigns(:room)
    assert_empty assigns(:available_rooms)
  end
  
end
