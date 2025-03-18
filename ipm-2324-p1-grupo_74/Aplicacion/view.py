from __future__ import annotations
from typing import Callable
import gi
import urllib.request
import locale
gi.require_version('Gtk', '4.0')
from gi.repository import Gtk, GObject
from gi.repository import GdkPixbuf

import gettext

_ = gettext.gettext
N_ = gettext.ngettext

class DrinkObject(GObject.GObject):
    def __init__(self, name):
        super().__init()
        self._name = name

    @GObject.Property(type=str)
    def name(self):
        return self._name

    def __repr__(self):
        return f"DrinkObject(name={self._name})"

def run(application_id: str, on_activate: Callable) -> None:
    app = Gtk.Application(application_id=application_id)
    app.connect('activate', on_activate)
    app.run()

class View:
    def __init__(self):
        self.handler = None
        self.button = []
        self.error_label = None
        self.scrolled_window = None
        self.switch = None
        self.search_bar = None
        self.spinner = Gtk.Spinner()
        self.spinnerF = Gtk.Spinner()
        self.return_button = None
        self.new_content = None
        self.boxFoto = None
        self.stillInInfo = False
        self.searchRes = None
	
    def set_handler(self, handler) -> None:
        self.handler = handler

    def on_activate(self, app) -> None:
        self.build(app)

    def build(self, app) -> None:
        self.window = win = Gtk.ApplicationWindow(title="4lcoolIsm0")
        app.add_window(win)
        win.connect("destroy", lambda win: win.close())

        self.switch = Gtk.Switch()
        self.switch.set_active(False)
        self.switch_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
        self.label = Gtk.Label(label=_("Search by name / ingredient"))
        self.switch_box.append(self.label)
        self.switch.connect("state-set", self.ingrediente)
        self.switch_box.append(self.switch)

        self.search_bar = Gtk.SearchEntry(
            placeholder_text=_("Search by name"),
            hexpand=False,
            margin_start=15,
            margin_end=15,
        )

        self.switch_box.append(self.search_bar)

        self.search_button = Gtk.Button(label=_("Search"), hexpand=False, margin_start=100, margin_end=100)
        self.search_button.connect('clicked', lambda _wg: self.handler.on_search_clicked(self.check_button1.get_active(), self.switch.get_state(), self.search_bar.get_text()))
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        box.set_margin_top(12)
        box.set_margin_start(12)
        box.set_margin_end(12)
        box.set_margin_bottom(12)
        box.append(self.switch_box)
        box.append(self.search_button)

        self.check_button1 = Gtk.CheckButton(label=_("No Alcohol"), hexpand=False, margin_start=100, margin_end=100)
        self.check_button1.connect('toggled', self.sinAlcohol)
        box.append(self.check_button1)
        box.append(self.spinner)
        win.set_child(box)
        win.set_default_size(800, 600)
        win.present()
 
 
    def update(self, text: list) -> None:
        
        self.searchRes = text
        
        self.search_button.set_sensitive(True)
        self.search_bar.set_sensitive(True)
        self.switch.set_sensitive(True)
        self.spinner.stop()
        self.check_button1.set_sensitive(True)
        
        if self.scrolled_window is not None:
            self.window.get_child().remove(self.scrolled_window)
            self.scrolled_window = None
        
        if self.error_label is not None:
            self.window.get_child().remove(self.error_label)
            self.error_label = None
        
        if text is not None:
            if text[0].get_error() == "Barra de búsqueda vacía":
                return


        if text is None or len(text) == 0:
            self.error_label = Gtk.Label(label=_("No results"), hexpand=False, margin_start=100, margin_end=100)
            self.window.get_child().append(self.error_label)
            return

        count = len(text)

        if text[0].get_error() is not None:
            if text[0].get_statusCode() != 200:
                self.error_label = Gtk.Label(label=_("COnexion Error"), hexpand=False, margin_start=100, margin_end=100)
                self.window.get_child().append(self.error_label)
                return
            else:
                self.error_label = Gtk.Label(label=_("No results"), hexpand=False, margin_start=100, margin_end=100)
                self.window.get_child().append(self.error_label)
                return

        self.button = []
        self.box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)

        max_button_width = max([len(item.get_strDrink()) for item in text])
        
        j = 0
        for i in range(count):
            if self.check_button1.get_active():
                    if text[i].get_alcohol():
                        j += 1
                        continue;
            button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
            but = Gtk.Button(label=text[i].get_strDrink())
            but.set_property("width-request", max_button_width * 10)  # Establece un ancho fijo
            button_box.append(but)
            self.button.append(but)
            self.button[i - j].connect("clicked", lambda _wg, i=i: self.handler.info(text[i]))
            self.box.append(button_box)
        if j == count:
            self.error_label = Gtk.Label(label=_("No results"), hexpand=False, margin_start=100, margin_end=100)
            self.window.get_child().append(self.error_label)
        
        alignment = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
        alignment.set_halign(Gtk.Align.CENTER)
        alignment.append(self.box)

        self.scrolled_window = Gtk.ScrolledWindow()
        self.scrolled_window.set_vexpand(True) 
        self.scrolled_window.set_child(alignment)
        self.window.get_child().append(self.scrolled_window)

    def idioma(self, result):
        if locale.getlocale()[0].startswith('es_') and result.get_InstructionsE() is not None:
            return result.get_InstructionsE()
        elif locale.getlocale()[0].startswith('de_') and result.get_InstructionsD() is not None:
            return result.get_InstructionsD()
        elif locale.getlocale()[0].startswith('fr_') and result.get_InstructionsF() is not None:
            return result.get_InstructionsF()
        elif locale.getlocale()[0].startswith('it_') and result.get_InstructionsI() is not None:
            return result.get_InstructionsI()
        else:
            return result.get_Instructions()
   

    def updateInfo(self, result):
        current_content = self.window.get_child()
        self.window.set_child(None)

        self.search_button.set_sensitive(True)
        self.search_bar.set_sensitive(True)
        self.switch.set_sensitive(True)
        self.spinner.stop()
        self.check_button1.set_sensitive(True)
        for but in self.button:
            but.set_sensitive(True)

        self.return_button = Gtk.Button(label=_("Back"), hexpand=False, margin_start=100, margin_end=100)
        self.return_button.connect('clicked', self.return_to_original_content, current_content)

        cocktail_label = Gtk.Label(label=result.get_strDrink(), hexpand=False, margin_start=100, margin_end=100)

        self.new_content  = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.new_content.append(self.return_button)
        self.new_content.append(cocktail_label)

        sl_text = Gtk.ScrolledWindow()
        textview = Gtk.TextView()
        textview.set_wrap_mode(Gtk.WrapMode.WORD)
        buf = textview.get_buffer()
        buf.set_text(self.idioma(result))
        textview.set_editable(False)
        textview.set_top_margin(0)
        textview.set_bottom_margin(20)
        textview.set_left_margin(10)
        textview.set_right_margin(10)

        sl_text.set_child(textview)
        sl_text.set_min_content_width(200)
        sl_text.set_min_content_height(100)
        
        
        self.new_content.append(sl_text)
        
        self.boxFoto = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
        self.boxFoto.append(self.spinnerF)
        self.new_content.append(self.boxFoto)

        ingredients_label = Gtk.Label(label=_("Ingredients:"))
        self.new_content.append(ingredients_label)

        ingredients_list = (result.get_strIngredients(), result.get_strCant())
        combined_lists = zip(ingredients_list[0], ingredients_list[1])
        for ingredient, cant in combined_lists:
            ingredient_label = Gtk.Label(label=f"- {ingredient} {cant}")
            self.new_content.append(ingredient_label)

        scrolled_window = Gtk.ScrolledWindow()
        scrolled_window.set_vexpand(True)
        scrolled_window.set_child(self.new_content )
        self.window.set_child(scrolled_window)
        textview.queue_draw()
        self.window.present()
        self.stillInInfo = True
        self.handler.prepareFoto(result)
    
    def updateInfoF(self, image_data):
        self.spinnerF.stop()
        image = Gtk.Picture()

        if image_data is None:
           with open("./imagenNoEncontrada.png", "rb") as f:
               image_data = f.read()
        
        loader = GdkPixbuf.PixbufLoader()
        loader.write(image_data)
        loader.close()
        new_width = 350
        new_height = 350
        image.set_pixbuf(loader.get_pixbuf().scale_simple(new_width, new_height, GdkPixbuf.InterpType.BILINEAR))
        
        if self.stillInInfo:
           self.boxFoto.append(image)
           self.window.present()
    
    def return_to_original_content(self, button, current_content):
        self.stillInInfo = False
        self.window.set_child(current_content)

   
 
    def prepararUpdate(self):
        if self.scrolled_window is not None:
            self.window.get_child().remove(self.scrolled_window)
            self.scrolled_window = None
 
        self.scrolled_window = Gtk.ScrolledWindow()
        self.scrolled_window.set_vexpand(True) 
   
    def sinAlcohol(self, button):
        if button.get_active():
            self.prepararUpdate()
            if self.searchRes == None or self.searchRes[0].get_error() == "Barra de busqueda vacia":
                self.window.get_child().append(self.scrolled_window)
                return
            self.button = []
            self.box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
            if self.error_label != None:
                self.window.get_child().remove(self.error_label)
                self.error_label = None
            
            if self.searchRes[0].get_statusCode() == 400:
                self.error_label = Gtk.Label(label=_("No conexion"), hexpand=False, margin_start=100, margin_end=100)
                self.window.get_child().append(self.error_label)
                alignment = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
                alignment.set_halign(Gtk.Align.CENTER)
                alignment.append(self.box)
                self.scrolled_window.set_child(alignment)
                self.window.get_child().append(self.scrolled_window)
                return
            max_button_width = max([len(item.get_strDrink()) for item in self.searchRes])
            i = 0
            for x in self.searchRes:
                if not x.get_alcohol():
        
                    button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
                    but = Gtk.Button(label=x.get_strDrink())
                    but.set_property("width-request", max_button_width * 10)  # Establece un ancho fijo
                    button_box.append(but)
                    self.button.append(but)
                    self.button[i].connect("clicked", lambda _wg, x=x: self.handler.info(x))
                    self.box.append(button_box) 
                    i += 1
            if len(self.button) == 0:
                self.error_label = Gtk.Label(label=_("No results"), hexpand=False, margin_start=100, margin_end=100)
                self.window.get_child().append(self.error_label)
            alignment = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
            alignment.set_halign(Gtk.Align.CENTER)
            alignment.append(self.box)
            self.scrolled_window.set_child(alignment)
            self.window.get_child().append(self.scrolled_window)
        else:
        
            self.prepararUpdate()
            if self.searchRes == None or self.searchRes[0].get_error() == "Barra de busqueda vacia":
                self.window.get_child().append(self.scrolled_window)
                return
                
            if self.error_label != None:
                self.window.get_child().remove(self.error_label)
                self.error_label = None
            self.button = []
            self.box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=12)
            if self.searchRes[0].get_statusCode() == 400:
                self.error_label = Gtk.Label(label=_("No conexion"), hexpand=False, margin_start=100, margin_end=100)
                self.window.get_child().append(self.error_label)
                alignment = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
                alignment.set_halign(Gtk.Align.CENTER)
                alignment.append(self.box)
                self.scrolled_window.set_child(alignment)
                self.window.get_child().append(self.scrolled_window)
                return
            i = 0 
            max_button_width = max([len(item.get_strDrink()) for item in self.searchRes])
            for x in self.searchRes:
        
                button_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL)
                but = Gtk.Button(label=x.get_strDrink())
                but.set_property("width-request", max_button_width * 10)  # Establece un ancho fijo
                button_box.append(but)
                self.button.append(but)
                self.button[i].connect("clicked", lambda _wg, x=x: self.handler.info(x))
                self.box.append(button_box)
                i += 1
            alignment = Gtk.Box(orientation=Gtk.Orientation.VERTICAL)
            alignment.set_halign(Gtk.Align.CENTER)
            alignment.append(self.box)
            self.scrolled_window.set_child(alignment)
            self.window.get_child().append(self.scrolled_window)
   
    def cadena(self, switch, state):
        return f"Search by {'name' if state else 'ingredient'}"

    def ingrediente(self, switch, state):
        if self.search_bar:
            self.switch_box.remove(self.search_bar)
            self.search_bar = None

        self.search_bar = Gtk.SearchEntry(
            placeholder_text=self.cadena(self.switch, self.switch.get_state()),
            hexpand=False,
            margin_start=15,
            margin_end=15,
        )
        self.switch_box.append(self.search_bar)

        self.window.present()
        print(f"Search by {'ingredient' if state else 'name'}")
