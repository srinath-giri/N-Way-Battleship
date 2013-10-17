require "spec_helper"

describe GridsController do
  describe "routing" do

    it "routes to #index" do
      get("/grids").should route_to("grids#index")
    end

    it "routes to #new" do
      get("/grids/new").should route_to("grids#new")
    end

    it "routes to #show" do
      get("/grids/1").should route_to("grids#show", :id => "1")
    end

    it "routes to #edit" do
      get("/grids/1/edit").should route_to("grids#edit", :id => "1")
    end

    it "routes to #create" do
      post("/grids").should route_to("grids#create")
    end

    it "routes to #update" do
      put("/grids/1").should route_to("grids#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/grids/1").should route_to("grids#destroy", :id => "1")
    end

  end
end
