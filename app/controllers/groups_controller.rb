class GroupsController < ApplicationController
	# http://courses.growthschool.com/courses/rails-101/lectures/229615
	before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]

	def index
		@groups = Group.all
	end

	def show
		@group = Group.find(params[:id])
		@posts = @group.posts
	end

	def new
		@group = Group.new
	end

	def edit
		# @group = Group.find(params[:id])
		@group = current_user.groups.find(params[:id])
	end

	def create
		# @group = Group.create(group_params)
		@group = current_user.groups.new(group_params)

		if @group.save
			current_user.join!(@group)
			redirect_to groups_path, notice: "新增討論版成功"
		else
			render :new
		end
	end

	def update
		# @group = Group.find(params[:id])
		@group = current_user.groups.find(params[:id])

		if @group.update(group_params)
		 redirect_to groups_path, notice: "修改討論版成功"
		else
		 render :edit
		end
	end

	def destroy
		# @group = Group.find(params[:id])
		@group = current_user.groups.find(params[:id])

		@group.destroy
		redirect_to groups_path, alert: "討論版已刪除"
	end

	def join
		@group = Group.find(params[:id])

		if !current_user.is_member_of?(@group)
			current_user.join!(@group)
			flash[:notice] = "加入本討論版成功！"
		else
			flash[:warning] = "你已經是本討論版成員！"
		end

		redirect_to group_path(@group)
	end

	def quit
		@group = Group.find(params[:id])

		if current_user.is_member_of?(@group)
			current_user.quit!(@group)
			flash[:alert] = "已經退出本討論版！"
		else
			flash[:warning] = "你不是本討論成員！"
		end

		redirect_to group_path(@group)
	end

	private

	def group_params
		params.require(:group).permit(:title, :description)
	end
end
