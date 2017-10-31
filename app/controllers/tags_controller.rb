class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :update, :destroy]

  # GET /tags
  def index
    @tags = Tag.find_each
    render_json(@tags)
  end

  # GET /tags/stats
  def stats
    @tags = Tag.breed_statistics
    render_json(@tags)
  end

  # GET /tags/1
  def show
    render_json(@tag)
  end

  # PATCH/PUT /tags/1
  def update
    if @tag.update(tag_params)
      render_json(@tag)
    else
      render json: @tag.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tags/1
  def destroy
    @tag.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = Tag.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def tag_params
      params.require(:tag).permit(:title)
    end
end
