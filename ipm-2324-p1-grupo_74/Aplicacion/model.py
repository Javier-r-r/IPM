import requests
import json
import urllib.request

class Drink():
	def __init__(self):
		self.error = None
		self.strDrink = None
		self.Instructions = None
		self.InstructionsE = None
		self.InstructionsD = None
		self.InstructionsF = None
		self.InstructionsI = None
		self.strDrinkImage = None
		self.strIngredients = []
		self.strCant = []
		self.statusCode = None
		self.alcohol = None
		
	def set_strDrink(self, drink: str):
		self.strDrink = drink
	def set_Instructions(self, Instructions):
		self.Instructions = Instructions
	def set_InstructionsE(self, InstructionsE):
		self.InstructionsE = InstructionsE
	def set_InstructionsD(self, InstructionsD):
		self.InstructionsD = InstructionsD
	def set_InstructionsF(self, InstructionsF):
		self.InstructionsF = InstructionsF
	def set_InstructionsI(self, InstructionsI):
		self.InstructionsI = InstructionsI
	def set_strDrinkImage(self, strDrinkImage):
		self.strDrinkImage = strDrinkImage
	def set_strIngredients(self, Ingre):
		self.strIngredients.append(Ingre)
	def set_strCant(self, cant):
		self.strCant.append(cant)
	def set_error(self, error):
		self.error = error
	def set_statusCode(self, statusCode):
		self.statusCode = statusCode
	def set_alcohol(self, alcohol):
		self.alcohol = alcohol
	
	def get_alcohol(self):
		return self.alcohol
		
	def get_error(self):
		return self.error
	def get_strDrink(self):
		return self.strDrink
	def get_Instructions(self):
		return self.Instructions
	def get_InstructionsE(self):
		return self.InstructionsE
	def get_InstructionsD(self):
		return self.InstructionsD
	def get_InstructionsF(self):
		return self.InstructionsF
	def get_InstructionsI(self):
		return self.InstructionsI
	def get_strDrinkImage(self):
		return self.strDrinkImage
	def get_strIngredients(self):
		return self.strIngredients
	def get_strCant(self):
		return self.strCant
	def get_statusCode(self):
		return self.statusCode
		
	


class Model():
	def __init__(self):
		pass
		
	#esta funcion comprueba si una bebida es alcoholica o no y obtiene todos los datos de la bebidas buscadas por ingrediente
	def sinAlcoholic(self, data):
		if "strAlcoholic" not in  data:
			req = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=" + data["idDrink"]
			
			try:
				response = requests.get(req)
			except requests.exceptions.ConnectionError as error:
				return (None, error)
			
			try:
				data = response.json() # Intenta analizar la respuesta JSON
			except json.JSONDecodeError as error:
				return (None, error)
			
			
			#esto se usa para darle valores al objeto Drink cuando es una busqueda por ingrediente 	
			dr = Drink()
			dr.set_strDrink(data["drinks"][0]["strDrink"])
			dr.set_strDrinkImage(data["drinks"][0]["strDrinkThumb"])
			dr.set_Instructions(data["drinks"][0]["strInstructions"])
			dr.set_InstructionsE(data["drinks"][0]["strInstructionsES"])
			dr.set_InstructionsD(data["drinks"][0]["strInstructionsDE"])
			dr.set_InstructionsF(data["drinks"][0]["strInstructionsFR"])
			dr.set_InstructionsI(data["drinks"][0]["strInstructionsIT"])
			
			for i in range(15):
				pos = str(i + 1)
				varName = "strIngredient" + pos
				varName2 = "strMeasure" + pos
				if data["drinks"][0][varName] != None:
					dr.set_strIngredients(data["drinks"][0][varName])
					dr.set_strCant(data["drinks"][0][varName2])
				else:
					break
			dr.set_alcohol(data["drinks"][0]["strAlcoholic"] == "Alcoholic")
			return (data["drinks"][0]["strAlcoholic"] != "Alcoholic", dr)
		else:
			#esto se usa para darle valores al objeto Drink cuando es una busqueda por nombre (al haber sido ya tratado el
			#jason antes los parametros son diferentes)
			dr = Drink()
			dr.set_strDrink(data["strDrink"])
			dr.set_strDrinkImage(data["strDrinkThumb"])
			dr.set_Instructions(data["strInstructions"])
			dr.set_InstructionsE(data["strInstructionsES"])
			dr.set_InstructionsD(data["strInstructionsDE"])
			dr.set_InstructionsF(data["strInstructionsFR"])
			dr.set_InstructionsI(data["strInstructionsIT"])
		
			for i in range(15):
				pos = str(i + 1)
				varName = "strIngredient" + pos
				varName2 = "strMeasure" + pos
				if data[varName] != None:
					dr.set_strIngredients(data[varName])
					dr.set_strCant(data[varName2])
				else:
					break
		
			dr.set_alcohol(data["strAlcoholic"] == "Alcoholic")
			return (data["strAlcoholic"] != "Alcoholic", dr)	
			
			
				
	#esta funcion realiza la busqueda de la bebida por nombre y o por ingrediente	
	def do_search(self, ingredient: bool, sin_alcohol: bool, searchDrink: str):
		drinks = []
		searchDr = searchDrink.strip()
		
		if len(searchDr) == 0:
			dr = Drink()
			dr.set_error("Barra de busqueda vacia")
			dr.set_statusCode(200)
			drinks.append(dr)
			return drinks
		
		if ingredient:
			#request para buscar por ingrediente
			req = "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=" + searchDr 
			
		else:
			#request para buscar por nombre de la bebida
			req = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=" + searchDr 
		
		try:
			response = requests.get(req)
		except requests.exceptions.ConnectionError as error:
			dr = Drink()
			dr.set_statusCode(400)
			dr.set_error(error)
			drinks.append(dr)
			return drinks		
		
		try:
			data = response.json() # Intenta analizar la respuesta JSON
		except json.JSONDecodeError as error:
			dr = Drink()
			dr.set_statusCode(response.status_code)
			dr.set_error(error)
			drinks.append(dr)
			return drinks
			
					
		if data["drinks"] != None:	
			for i in data["drinks"]:
				res = self.sinAlcoholic(i)
				if(res[0] == None):
					dr = Drink()
					dr.set_error(res[1])
					drinksErr = []
					drinksErr.append(dr)
					return drinksErr
				else: #muestra todos los resultados
					dr = Drink()
					dr = res[1]
					drinks.append(dr)
						
		else:
			drinks = None			
		return drinks


	def getImage(self, drink):
		url = drink.get_strDrinkImage()
		try:
			image_data = urllib.request.urlopen(url).read()
		except Exception as e:
			image_data = None
			
		return image_data

				



