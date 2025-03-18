from model import Model
from view import View, run
import threading
from gi.repository import GLib

class Presenter:
	def __init__(self, model: Model, view: View):
		self.model = model
		self.view = view


	def run(self, application_id: str):
		self.view.set_handler(self)
		run(application_id=application_id, on_activate=self.view.on_activate)


	def on_search_clicked(self, sin_alcohol: bool,  searchIngredient: bool, name: str) -> None:
		if self.view.error_label is not None:
			self.view.window.get_child().remove(self.view.error_label)
			self.view.error_label = None
		threading.Thread(target = self.do_work, args=(sin_alcohol, searchIngredient, name), daemon=True).start()
		
	def do_work(self, sin_alcohol: bool,  searchIngredient: bool, name: str):
		GLib.idle_add(self._waiting)
		result = self.model.do_search(searchIngredient, sin_alcohol, name)
		GLib.idle_add(self.view.update, result)
	
	
	def _waiting(self) -> None:
		self.view.spinner.start()
		self.view.search_button.set_sensitive(False)
		self.view.search_bar.set_sensitive(False)
		for but in self.view.button:
			but.set_sensitive(False)
		self.view.check_button1.set_sensitive(False)
		self.view.switch.set_sensitive(False)
	
	
	
	
	
	def info(self, drink):
		# Esta función se llama cuando se hace clic en un botón de cóctel
		self.view.updateInfo(drink)
		#threading.Thread(target = self.do_workInfo, args=(drink,), daemon=True).start()
        
        
        
	def prepareFoto(self, drink):
		threading.Thread(target = self.do_workFoto, args=(drink,), daemon=True).start()
        	
        
	def do_Foto(self, drink: str):

		image_data = self.model.getImage(drink)

		if image_data is None:
		
			return None

		return image_data
        
	def _waitingF(self):
		self.view.spinnerF.start()
        	
        	
	def do_workFoto(self, drink):
		GLib.idle_add(self._waitingF)
		image = self.do_Foto(drink)
		GLib.idle_add(self.view.updateInfoF, image)

    





