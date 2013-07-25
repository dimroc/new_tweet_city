class SnapshotsController < ApplicationController
  before_filter :safely_assign_area

  def index
    @snapshots = Snapshot.public_send(@area).ascending
  end

  def show
    relation = Snapshot.public_send(@area)

    @snapshot = relation.find(params[:id])
    @next = relation.where("ends_at > ?", @snapshot.ends_at).order("ends_at ASC").first
    @previous = relation.where("ends_at < ?", @snapshot.ends_at).order("ends_at DESC").first
  end

  def last
    redirect_to snapshot_path(@area, Snapshot.public_send(@area).last)
  end

  private

  def safely_assign_area
    @area = params[:area] || "manhattan"
    raise ActiveRecord::RecordNotFound unless ["nyc", "manhattan"].include? @area
  end
end
