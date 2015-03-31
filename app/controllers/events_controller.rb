class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json
  def index
    @events = Event.all
    @people = Person.all
  end

  # GET /events/1
  # GET /events/1.json
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
    @people = Person.all
    @person = Person.new
  end

  # GET /events/1/edit
  def edit
    @people = Person.all
  end

  # POST /events
  # POST /events.json
  def create
    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save

        @event.cost_per_person = @event.cost_total / @event.att_nr

        event_attendees.each do |email, cnt|
          @event.people << Person.find_by(email: email)
        end

        # update payer's money
        payer = Person.find_by(id: @event.payer_id)
        payer.money += @event.cost_total
        payer.save
        @event.save

        # update each attendee's money
        event_attendees.each do |email, cnt|
          person = Person.find_by(email: email)
          person.money -= @event.cost_per_person * cnt
          person.save
        end

        # record the cost of each person at each event
        event_attendees.each do |email, cnt|
          person = Person.find_by(email: email)
          cost = Cost.new
          cost.att_nr = cnt
          cost.money = @event.cost_per_person * cnt
          cost.save

          person.costs << cost
          @event.costs << cost

        end


        email_obj = {}
        # email_obj["to"] = Person.all.map{|p| p.email}
        email_obj["to"] = 'hongbin.zhou@nuance.com'
        email_obj["subject"] = 'Badminton Expense Update'
        email_obj["body"] = render_to_body(:template => "events/index", :layout => false)

        begin
          UserMailer.deliver_report(email_obj).deliver
          format.html { redirect_to @event, notice: 'Event was successfully created. Email send successfully!' }
          format.json { render :show, status: :created, location: @event }
        rescue EOFError, StandardError 
          flash[:success] = "creato. Problems sending mail"
          format.html { redirect_to @event, notice: 'Event was successfully created. Email send failed!' }
          format.json { render :show, status: :created, location: @event }
        end

      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy

    # Cancle the cost of this event for each person
    Person.all.each do |person|
      cost = Cost.find_by(event_id: @event["id"], person_id: person["id"])
      if cost
        person.money += cost.money
        person.save
      end
    end

    # Cancle the payer's payment
    payer = Person.find_by(id: @event.payer_id)
    payer.money -= @event.cost_total
    payer.save

    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      p = params.require(:event).permit(:date, :place, :cost_total, :payer_id)

      params.require(:event).permit(:attendees).tap do |event|
        event[:attendees] = params[:event][:attendees]
        p["att_nr"] = event[:attendees].values.map{ |s| s.to_i }.inject(:+)
      end

      return p
    end

    def event_attendees
      attendees={}
      params[:event][:attendees].each do |email, cnt|
          attendees[email]=cnt.to_i if cnt.to_i > 0
      end
      attendees
    end
end
