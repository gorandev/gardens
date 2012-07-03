class AlertsController < ApplicationController

  def index
    @alerts = Alert.all
    @pagina = 'Alertas'
  end

  def create
    ruletype_signature = String.new

    if params.has_key?(:porcentaje_precio)
      ruletype_signature += 'Cambio de precio' + params[:porcentaje_precio]
    else 
      ruletype_signature += 'Cambio de precio0'
    end

    if params.has_key?(:marca) && !params[:marca].empty?
      if !ruletype_signature.empty?
        ruletype_signature += ','
      end
      ruletype_signature += 'Marca' + params[:marca]
    end

    if params.has_key?(:producto) && !params[:producto].empty?
      if !ruletype_signature.empty?
        ruletype_signature += ','
      end
      ruletype_signature += 'Producto' + params[:producto]
    end

    if params.has_key?(:retailer) && !params[:retailer].empty?
      if !ruletype_signature.empty?
        ruletype_signature += ','
      end
      ruletype_signature += 'Retailer' + params[:retailer]
    end

    Alert.where(:user_id => current_user.id).each do |a|
      if a.ruletype_signature == ruletype_signature
        return render :json => { :errors => { :alert => "already exists" } }, :callback => params[:callback]
      end
    end

    alert = Alert.create( 
      :user => current_user,
      :event => Event.last
    )

    rules = Array.new

    if params.has_key?(:retailer) && !params[:retailer].empty?
      rules.push(Rule.create(
        :alert => alert,
        :rule_type => RuleType.find_by_description('Retailer'),
        :value => params[:retailer]
      ))
    end

    if params.has_key?(:marca) && !params[:marca].empty?
      rules.push(Rule.create(
        :alert => alert,
        :rule_type => RuleType.find_by_description('Marca'),
        :value => params[:marca]
      ))
    end

    if params.has_key?(:producto) && !params[:producto].empty?
      rules.push(Rule.create(
        :alert => alert,
        :rule_type => RuleType.find_by_description('Producto'),
        :value => params[:producto]
      ))
    end

    if params.has_key?(:porcentaje_precio)
      rules.push(Rule.create(
        :alert => alert,
        :rule_type => RuleType.find_by_description('Cambio de precio'),
        :value => params[:porcentaje_precio]
      ))
    else
      rules.push(Rule.create(
        :alert => alert,
        :rule_type => RuleType.find_by_description('Cambio de precio')
      ))
    end

    alert.rules = rules
    alert.save

    render :json => { :id => alert.id }, :callback => params[:callback]
  end
  
  def update
    unless alert  = Alert.find_by_id(params[:id])
      return render :json => { :errors => { :id => "must be valid" } }, :status => 400
    end

    alert.user = current_user
    
    if params.has_key?(:value)
    	alert.value = params[:value]
    end
    
    if params.has_key?(:event)
      unless event = Event.find_by_id(params[:event])
        return render :json => { :errors => { :event => "must be valid" } }, :status => 400
      else
        alert.event = event
      end
    end

    if params.has_key?(:rules)
      if params[:rules].is_a?String
        rules = Rule.find_all_by_id(params[:rules].split(','))
        pv_param_size = params[:rules].split(',').size
      else
        if params[:rules].is_a?Array
          pv_param_size = params[:rules].size
        end
        rules = Rule.find_all_by_id(params[:rules])
      end

      if property_values.empty? || property_values.size != pv_param_size
        return render :json => { :errors => { :rules => "must be all valid" } }, :status => 400
      else
        if params[:rules].is_a?String
          alert.rules << rules
        else
          alert.rules = rules
        end
      end
    end

    if alert.attributes == Alert.find_by_id(params[:id]).attributes
      return render :json => { :errors => { :alert => "nothing to update" } }
    end
    
    if alert.save
      render :json => { :id => alert.id }
    else
      render :json => { :errors => alert.errors }, :status => 400
    end
  end

  def destroy
    unless alert = Alert.find_by_id(params[:id])
      return render :json => { :errors => { :alert => "must be valid" } }, :status => 400
    end
    alert.rules.each do |r|
      r.destroy
    end
    alert.destroy
    render :nothing => true
  end
end
