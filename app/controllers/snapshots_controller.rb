class SnapshotsController < ApplicationController
  def index
    @snapshots = Snapshot.all
  end

  def show
    @snapshot = Snapshot.find(params[:id])
  end

  def last
    @snapshot = Snapshot.last
    render :show
  end
end
