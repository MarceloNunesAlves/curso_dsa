# Matriz de Adjacência

# Imports
import abc
import numpy as np


# A representação da classe base de um Grafo com todos os métodos de interface
class Graph(abc.ABC):

	def __init__(self, numVertices, directed=False):
		self.numVertices = numVertices
		self.directed = directed

	@abc.abstractmethod
	def add_edge(self, v1, v2, weight):
		pass

	@abc.abstractmethod
	def get_adjacent_vertices(self, v):
		pass	

	@abc.abstractmethod
	def display(self):	
		pass


# Representa um grafo como uma matriz de adjacência. 
# Uma célula na matriz tem um valor quando existe uma aresta entre o vértice representado pelos números de linha e coluna. 
# Grafos ponderados podem conter valores > 1 nas células da matriz 
# Um valor de 0 na célula indica que não há aresta
class AdjacencyMatrixGraph(Graph):

	# Inicializa a classe
	def __init__(self, numVertices, directed=False):
		super(AdjacencyMatrixGraph, self).__init__(numVertices, directed)

		self.matrix = np.zeros((numVertices, numVertices)) 

	# Adiciona uma aresta
	def add_edge(self, v1, v2, weight=1):
		if v1 >= self.numVertices or v2 >= self.numVertices or v1 < 0 or v2 < 0:
			raise ValueError("Vertices %d e %d estão fora dos limites" % (v1, v2))

		if weight < 1:
			raise ValueError("Uma aresta não pode ter peso < 1")	

		# Inclui um valor na matriz (se for grafo direcionado, isso é suficiente)
		self.matrix[v1][v2] = weight

		# Se for grafo não direcionado, inclui mais um valor na matriz
		if self.directed == False:
			self.matrix[v2][v1] = weight


	# Obtém os vértices adjacentes
	def get_adjacent_vertices(self, v):
		if v < 0 or v >= self.numVertices:
			raise ValueError("Não pode acessar o node %d" % v)

		# Cria matriz vazia
		adjacent_vertices = []

		# Preenche a matriz
		for i in range(self.numVertices):
			if self.matrix[v][i] > 0:
				adjacent_vertices.append(i)

		return adjacent_vertices		

	# Display
	def display(self):
		for i in range(self.numVertices):
			for v in self.get_adjacent_vertices(i):
				print(i, "-->", v)


# Executando o grafo e criando a matriz

# Matriz para grafo direcionado
g = AdjacencyMatrixGraph(4, directed=True)

# Matriz para grafo não direcionado
#g = AdjacencyMatrixGraph(4)

# Adiciona as arestas
g.add_edge(0, 1)
g.add_edge(0, 2)
g.add_edge(2, 3)


# Print

print("\nMatriz de Adjacência:")
print(g.matrix)

print("\nVisualizando Conexões (Arestas): ")
for i in range(4):
    print("Node", i, "conectado a", g.get_adjacent_vertices(i))

# Visualizando o grafo
print("\nVisualizando o Grafo: ")
g.display()
print("\n")



