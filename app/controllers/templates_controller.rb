class TemplatesController < ApplicationController
  # layout :choose_layout

  def index
    @templates = %w(haml erb).inject([]) do |templates, extension|
      templates + Dir.glob(File.join(Rails.root, 'app', 'views', 'templates', "*.#{extension}")).map do |filename|
        {:name => File.basename(filename, ".html.#{extension}"), :mtime => (Time.parse(`git log --format="%ad" --date=iso -1 #{filename}`) rescue Time.now)}
      end
    end.reject { |template| template[:name] == 'index' }.sort { |t1, t2| t2[:mtime] <=> t1[:mtime] }
  end

  def show
    respond_to do |format|
      format.html do
        render params[:template]
      end
    end
  end

  private

  #def choose_layout
  #  params[:layout] || 'templates'
  #end
end