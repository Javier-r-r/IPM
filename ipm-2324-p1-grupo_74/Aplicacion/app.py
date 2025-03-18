from model import Model
from view import View
from presenter import Presenter

import locale
import gettext

if __name__ == "__main__":
    locale.setlocale(locale.LC_ALL, '')
    LOCALE_DIR = "./locales"
    locale.bindtextdomain('ExampleApp', LOCALE_DIR)
    gettext.bindtextdomain('ExampleApp', LOCALE_DIR)
    gettext.textdomain('ExampleApp')
    presenter = Presenter(model=Model(), view=View())
    presenter.run(application_id="es.udc.fic.ipm.app_g74")
