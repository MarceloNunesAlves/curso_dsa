# Criando Grafo com Networkx

# Imports
import networkx as nx
import matplotlib.pyplot as plt

# Cria o Grafo
G = nx.Graph()

# Adicionar Nodes
G.add_node("a")
G.add_nodes_from(["b","c"])

# Adicionar Edges
edge = ("d", "e")
G.add_edge(*edge)

edge = ("a", "b")
G.add_edge(*edge)

# Adicionando todos os edges
G.add_edges_from([("a","c"), ("c","d"), ("a","d"), ("a","b")])

# Prints
print("\nNodes no Grafo: ")
print(G.nodes())
print("Edges no Grafo: ")
print(G.edges())

# Desenha o grafo e salva a imagem png
nx.draw(G)
plt.savefig("primeiro_grafo_nx.png") 
plt.show() 