class BreedsController < ApplicationController
  before_action :set_breed, only: [:update, :destroy, :tags]
  before_action :delete_hanging_tags, only: [:update, :destroy]

  # GET /breeds
  def index
    @breeds = Breed.find_each

    render_json(@breeds)
  end

  # GET /breeds/stats
  def stats
    @breeds = Breed.tag_statistics
    render_json(@breeds)
  end

  # GET /breeds/1
  def show
    @breed_with_tags = Breed.includes(:tags).find(params[:id]).to_json(:include => :tags)
    render_json(@breed_with_tags)
  end

  # POST /breeds
  def create
    @breed = Breed.new(breed_params)
    if @breed.save
      render json: @breed, status: :created, location: @breed
    else
      render json: @breed.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /breeds/1
  def update
    if @breed.update(breed_params)
      render_json(@breed)
    else
      render json: @breed.errors, status: :unprocessable_entity
    end
  end

  # DELETE /breeds/1
  def destroy
    @breed.destroy
  end

  # [GET, POST] /breeds/:breed_id/tags
  def tags
    send("#{request.method.downcase}_tags")
  end

  private

    def get_tags
      render_json(@breed.tags)
    end

    def post_tags
      delete_hanging_tags
      if @breed.create_tags(extract_tags(params[:tags] || []))
        render json: @breed.tags, status: :created, location: @breed
      else
        render json: @breed.errors, status: :unprocessable_entity
      end
    end

    def set_breed
      @breed = Breed.find(params[:id] || params[:breed_id])
    end

    def delete_hanging_tags
      @breed.delete_hanging_tags
    end

    def breed_params
      all_params = params.require(:breed).permit(:name, tags: [])
      tag_params = extract_tags(all_params[:tags]).collect{ |title| {tag_attributes: {title: title }} }
      all_params.except(:tags).merge({ taggables_attributes: tag_params })
    end

    def extract_tags(parameters)
      parameters || []
    end
end
