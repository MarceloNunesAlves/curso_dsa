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

	# Ontém o "indegree"
	def get_indegree(self, v):
		if v < 0 or v >= self.numVertices:
			raise ValueError("Não pode acessar o node %d" % v)

		indegree = 0
		for i in range(self.numVertices):
			if v in self.get_adjacent_vertices(i):
				indegree = indegree + 1	
		
		return indegree	
		
	# Display
	def display(self):
		for i in range(self.numVertices):
			for v in self.get_adjacent_vertices(i):
				print(i, "-->", v)



# Classe Node representa um único node em um set.
# Cada node possui um vertex_id
# Cada node é associado com um set de vértices adjacentes
class Node:
	def __init__(self, vertexId):
		self.vertexId = vertexId
		self.adjacency_set = set()

	def add_edge(self, v):
		if self.vertexId == v:
			raise ValueError("O vértice %d não pode ser adjacente a si mesmo" % v)

		self.adjacency_set.add(v)		

	def get_adjacent_vertices(self):
		return sorted(self.adjacency_set)	



# Representa um Set
class AdjacencySetGraph(Graph):

	def __init__(self, numVertices, directed=False):
		super(AdjacencySetGraph, self).__init__(numVertices, directed)

		self.vertex_list = []

		for i in range(numVertices):
			self.vertex_list.append(Node(i))

	# Adiciona uma aresta
	def add_edge(self, v1, v2, weight=1):
		if v1 >= self.numVertices or v2 >= self.numVertices or v1 < 0 or v2 < 0:
			raise ValueError("Vertices %d e %d estão fora dos limites" % (v1, v2))

		if weight != 1:
			raise ValueError("Uma aresta não pode ter peso >1")	

		# Inclui um valor no set (se for grafo direcionado, isso é suficiente)
		self.vertex_list[v1].add_edge(v2)

		# Se for grafo não direcionado, inclui mais um valor no set
		if self.directed == False:
			self.vertex_list[v2].add_edge(v1)

	# Obtém os vértices adjacentes
	def get_adjacent_vertices(self, v):
		if v < 0 or v >= self.numVertices:
			raise ValueError("Não pode acessar o node %d" % v)

		return self.vertex_list[v].get_adjacent_vertices()


	def display(self):
		for i in range(self.numVertices):
			for v in self.get_adjacent_vertices(i):
				print(i, "-->", v)
						



