class ConfigurationController < ApplicationController
  before_filter :login_required
  filter_access_to :all

  FILE_EXTENSIONS = [".jpg",".jpeg",".png"]#,".gif",".png"]
  FILE_MAXIMUM_SIZE_FOR_FILE=1048576

  def settings
    @config = Configuration.get_multiple_configs_as_hash ['InstitutionName', 'InstitutionAddress', 'InstitutionPhoneNo', \
        'StudentAttendanceType', 'CurrencyType', 'ExamResultType', 'AdmissionNumberAutoIncrement','EmployeeNumberAutoIncrement']

    if request.post?

      unless params[:upload].nil?
        @temp_file=params[:upload][:datafile]
        unless FILE_EXTENSIONS.include?(File.extname(@temp_file.original_filename).downcase)
          flash[:notice] = 'Extens�o inv�lida. Imagem deve ser .JPG'
          redirect_to :action => "settings"  and return
        end
        if @temp_file.size > FILE_MAXIMUM_SIZE_FOR_FILE
          flash[:notice] = 'Arquivo muito grande. Tamanho do arquivo deve ser menor que 1 MB'
          redirect_to :action => "settings" and return
        end
      end
    
      Configuration.set_config_values(params[:configuration])
      Configuration.save_institution_logo(params[:upload]) unless params[:upload].nil?

      flash[:notice] = 'As configura��es foram salvas'
      redirect_to :action => "settings"  and return
    end
  end
end