class SnapshotsController < ApplicationController
  def index
    @snapshots = Snapshot.all
  end

  def show
    @snapshot = Snapshot.find(params[:id])
    @next = Snapshot.where("ends_at > ?", @snapshot.ends_at).order("ends_at ASC").first
    @previous = Snapshot.where("ends_at < ?", @snapshot.ends_at).order("ends_at DESC").first
  end

  def last
    redirect_to snapshot_path(Snapshot.last)
  end
end
