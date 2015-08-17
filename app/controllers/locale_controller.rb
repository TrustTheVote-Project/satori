class LocaleController < BaseController

  def satori
    locale 'en'
    redirect_to :root
  end

  def eavs
    locale 'en-EAVS'
    redirect_to :root
  end

  private

  def locale(l)
    session[:locale] = l
  end

end
