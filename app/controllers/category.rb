ContentService::App.controllers :category do
  
  get :categoresy, :map => '/categories' do
    begin
      Category.where(enabled: true).only(:save_name, :display_name, :created_at, :updated_at).to_json
    rescue Exception => e
      logger.error "GET /categories Exception in categories GET params: #{params.inspect} #{e.inspect} #{e.backtrace}"
      return [422, {:reason => e.message, :text => 'Oops! Something went wrong!'}.to_json]
    end
  end

  post :category, :map => '/category' do
    logger.info "POST /category request: #{params.inspect}"
    if params[:save_name].nil? or params[:display_name].nil? or params[:save_name].empty? or params[:display_name].empty?
      logger.error "POST /user Invalid parameters: #{params.inspect}"
      return [400]
    end
    begin
    Category.create(save_name: params[:save_name], display_name: params[:display_name])
    rescue Exception => e
      logger.error "POST /category Exception in category create params: #{params.inspect} #{e.inspect} #{e.backtrace}"
      return [422, {:reason => e.message, :text => 'Oops! Something went wrong!'}.to_json]
    end
    return [201]
  end
end
