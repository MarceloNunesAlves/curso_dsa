# Set de Adjacência

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
						

# Executando o grafo e criando a matriz

# Matriz para grafo direcionado
g = AdjacencySetGraph(4, directed=True)

# Matriz para grafo não direcionado
#g = AdjacencySetGraph(4)

# Adiciona as arestas
g.add_edge(0, 1)
g.add_edge(0, 2)
g.add_edge(2, 3)

# Print

print("\nVisualizando Conexões (Arestas): ")
for i in range(4):
    print("Node", i, "conectado a", g.get_adjacent_vertices(i))

# Visualizando o grafo
print("\nVisualizando o Grafo: ")
g.display()
print("\n")


