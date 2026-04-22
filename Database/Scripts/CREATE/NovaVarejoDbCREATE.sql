CREATE DATABASE NovoVarejoDb
GO

USE NovoVarejoDb
GO

CREATE TABLE Pais 
(
	PaisId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomePais NVARCHAR(30) UNIQUE NOT NULL
);
GO

CREATE TABLE Estado
(
	EstadoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeEstado NVARCHAR(30) UNIQUE NOT NULL
);
GO

CREATE TABLE Cidade 
(
	CidadeId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeCidade NVARCHAR(50) UNIQUE NOT NULL
);
GO

CREATE TABLE CargoUsuario
(
	CargoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeCargo VARCHAR(20) UNIQUE NOT NULL
);
GO

CREATE TABLE StatusUsuario 
(
	StatusId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeStatus VARCHAR(20) UNIQUE NOT NULL
);
GO

CREATE TABLE Usuario 
(
	UsuarioId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	StatusId UNIQUEIDENTIFIER NOT NULL,
	CargoId UNIQUEIDENTIFIER NOT NULL,
	Nome NVARCHAR(50),
	Email VARCHAR(255) UNIQUE,
	Senha VARBINARY(32) NOT NULL,
	CPF VARCHAR(12) UNIQUE,
	DataNascimento DATETIME2,

	CONSTRAINT FK_Usuario_SatatusUsuario_StatusId FOREIGN KEY (StatusId) REFERENCES StatusUsuario(StatusId),
	CONSTRAINT FK_Usuario_CargoUsuario_CargoId FOREIGN KEY (CargoId) REFERENCES CargoUsuario(CargoId)
);
GO

CREATE TABLE EnderecoUsuario
(
	EnderecoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	Logradouro NVARCHAR(150),
	EstadoId UNIQUEIDENTIFIER NOT NULL,
	CidadeId UNIQUEIDENTIFIER NOT NULL,
	PaisId UNIQUEIDENTIFIER NOT NULL,

	CONSTRAINT FK_EnderecoUsuario_Usuario_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuario(UsuarioId),
	CONSTRAINT FK_EnderecoUsuario_Estado_EstadoId FOREIGN KEY (EstadoId) REFERENCES Estado(EstadoId),
	CONSTRAINT FK_EnderecoUsuario_Cidade_CidadeId FOREIGN KEY (CidadeId) REFERENCES Cidade(CidadeId),
	CONSTRAINT FK_EnderecoUsuario_Pais_PaisId FOREIGN KEY (PaisId) REFERENCES Pais(PaisId)
);
GO

CREATE TABLE TipoALteracaoUsuario
(
	TipoAlteracaoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeTipo VARCHAR(20)
);
GO

CREATE TABLE LogUsuario
(
	LogUsuarioId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	StatusId UNIQUEIDENTIFIER NOT NULL,
	CargoId UNIQUEIDENTIFIER NOT NULL,
	EnderecoId UNIQUEIDENTIFIER NOT NULL,
	TipoAlteracaoId UNIQUEIDENTIFIER NOT NULL,
	NomeUsuario NVARCHAR(50),
	Email VARCHAR(255) UNIQUE,
	Senha VARBINARY(32) NOT NULL,
	CPF VARCHAR(12) UNIQUE,
	DataNascimento DATETIME2, 
	DataLog DATETIME2 DEFAULT GETDATE(),

	CONSTRAINT FK_LogUsuario_TipoAlteracaoUsuario_TipoAlteracaoId FOREIGN KEY (TipoAlteracaoId) REFERENCES TipoAlteracaoUsuario(TipoAlteracaoId),
	CONSTRAINT FK_LogUsuario_Usuario_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuario(UsuarioId),
	CONSTRAINT FK_LogUsuario_StatusUsuario_StatusId FOREIGN KEY (StatusId) REFERENCES StatusUsuario(StatusId),
	CONSTRAINT FK_LogUsuario_CargoUsuario_CargoId FOREIGN KEY (CargoId) REFERENCES CargoUsuario(CargoId),
	CONSTRAINT FK_LogUsuario_EnderecoUsuario_EnderecoId FOREIGN KEY (EnderecoId) REFERENCES EnderecoUsuario(EnderecoId) 
);
GO


CREATE TABLE CategoriaProduto 
(
	CategoriaId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeCategoria NVARCHAR(30) UNIQUE NOT NULL
);
GO

CREATE TABLE StatusProduto
(
	StatusId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeStatus NVARCHAR(30) UNIQUE NOT NULL
);
GO

CREATE TABLE Produto
(
	ProdutoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeProduto NVARCHAR(50) UNIQUE NOT NULL,
	Preco DECIMAL(10, 2) NOT NULL,
	StatusId UNIQUEIDENTIFIER NOT NULL,
	CategoriaId UNIQUEIDENTIFIER NOT NULL,

	CONSTRAINT FK_Produto_StatusProduto_StatusId FOREIGN KEY (StatusId) REFERENCES StatusProduto(StatusId),
	CONSTRAINT FK_Produto_CategoriaProduto_CategoriaId FOREIGN KEY (CategoriaId) REFERENCES CategoriaProduto(CategoriaId)
);
GO


CREATE TABLE Carrinho
(
	CarrinhoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	ProdutoId UNIQUEIDENTIFIER NULL,

	CONSTRAINT FK_Carrinho_Produto_ProdutoId FOREIGN KEY (ProdutoId) REFERENCES Produto(ProdutoId)
);
GO

CREATE TABLE TipoALteracaoCarrinho
(
	TipoAlteracaoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeTipo VARCHAR(20)
);
GO

CREATE TABLE LogCarrinho
(
	CarrinhoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	ProdutoId UNIQUEIDENTIFIER NOT NULL,
	TipoAlteracaoId UNIQUEIDENTIFIER NOT NULL,
	DataLog DATETIME2 DEFAULT GETDATE(),

	CONSTRAINT FK_LogCarrinho_TipoAlteracaoCarrinho_TipoAlteracaoId FOREIGN KEY (TipoAlteracaoId) REFERENCES TipoAlteracaoCarrinho(TipoAlteracaoId),
	CONSTRAINT FK_LogCarrinho_Produto_ProdutoId FOREIGN KEY (ProdutoId) REFERENCES Produto(ProdutoId)

);
GO

CREATE TABLE EstoqueProduto
(
	UnidadeProdutoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	ProdutoId UNIQUEIDENTIFIER NOT NULL

	CONSTRAINT FK_EstoqueProduto_Produto_ProdutoId FOREIGN KEY (ProdutoId) REFERENCES Produto(ProdutoId)
);
GO

CREATE TABLE TipoALteracaoEstoqueProduto
(
	TipoAlteracaoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeTipo VARCHAR(20)
);
GO

CREATE TABLE LogEstoqueProduto
(
	LogEstoqueProdutoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	UnidadeProdutoId UNIQUEIDENTIFIER NOT NULL,
	ProdutoId UNIQUEIDENTIFIER NOT NULL,
	TipoAlteracaoId UNIQUEIDENTIFIER NOT NULL,
	DataLog DATETIME2 DEFAULT GETDATE(),

	CONSTRAINT FK_LogEstoqueProduto_TipoAlteracaoEstoqueProduto_TipoAlteracaoId FOREIGN KEY (TipoAlteracaoId) REFERENCES TipoAlteracaoEstoqueProduto(TipoAlteracaoId),
	CONSTRAINT FK_LogEstoqueProduto_EstoqueProduto_UnidadeProdutoId FOREIGN KEY (UnidadeProdutoId) REFERENCES EstoqueProduto(UnidadeProdutoId),
	CONSTRAINT FK_LogEstoqueProduto_Produto_ProdutoId FOREIGN KEY (ProdutoId) REFERENCES Produto(ProdutoId)
);
GO

CREATE TABLE StatusPedido 
(
	StatusPedidoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID() NOT NULL,
	NomeStatus VARCHAR(20)
);
GO

CREATE TABLE Pedido
(
	PedidoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	EnderecoId UNIQUEIDENTIFIER NOT NULL,
	StatusPedidoId UNIQUEIDENTIFIER NOT NULL,

	CONSTRAINT FK_Pedido_Usuario_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuario(UsuarioId),
	CONSTRAINT FK_Pedido_EnderecoUsuario_EnderecoId FOREIGN KEY (EnderecoId) REFERENCES EnderecoUsuario(EnderecoId),
	CONSTRAINT FK_Pedido_StatusPedido_StatusPedidoId FOREIGN KEY (StatusPedidoId) REFERENCES StatusPedido(StatusPedidoId),
);
GO

CREATE TABLE TipoALteracaoPedido
(
	TipoAlteracaoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeTipo VARCHAR(20)
);
GO

CREATE TABLE LogPedido
(
	LogPedidoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	UsuarioId UNIQUEIDENTIFIER NOT NULL,
	EnderecoId UNIQUEIDENTIFIER NOT NULL,
	TipoAlteracaoId UNIQUEIDENTIFIER NOT NULL,
	StatusPedidoId UNIQUEIDENTIFIER NOT NULL,

	CONSTRAINT FK_LogPedido_TipoAlteracaoPedido_TipoAlteracaoId FOREIGN KEY (TipoAlteracaoId) REFERENCES TipoAlteracaoPedido(TipoAlteracaoId),
	CONSTRAINT FK_LogPedido_Usuario_UsuarioId FOREIGN KEY (UsuarioId) REFERENCES Usuario(UsuarioId),
	CONSTRAINT FK_LogPedido_EnderecoUsuario_EnderecoId FOREIGN KEY (EnderecoId) REFERENCES EnderecoUsuario(EnderecoId),
	CONSTRAINT FK_LogPedido_StatusPedido_StatusPedidoId FOREIGN KEY (StatusPedidoId) REFERENCES StatusPedido(StatusPedidoId),
);
GO

CREATE TABLE ProdutoCarrinho
(
	ProdutoId UNIQUEIDENTIFIER NOT NULL,
	CarrinhoId UNIQUEIDENTIFIER NOT NULL,
	
	CONSTRAINT PK_ProdutoCarrinho_ProdutoId_CarrinhoId PRIMARY KEY (ProdutoId, CarrinhoId),
	CONSTRAINT FK_ProdutoCarrinho_Produto_ProdutoId FOREIGN KEY (ProdutoId) REFERENCES Produto(ProdutoId),
	CONSTRAINT FK_ProdutoCarrinho_CarrinhoId_CarrinhoId FOREIGN KEY (CarrinhoId) REFERENCES Carrinho(CarrinhoId)
);
GO

CREATE TABLE PedidoProduto
(
	ProdutoId UNIQUEIDENTIFIER NOT NULL,
	PedidoId UNIQUEIDENTIFIER NOT NULL,
	QuantidadeProduto INT,
	
	CONSTRAINT PK_PedidoProduto_ProdutoId_PedidoId PRIMARY KEY (ProdutoId, PedidoId),
	CONSTRAINT FK_PedidoProduto_Produto_ProdutoId FOREIGN KEY (ProdutoId) REFERENCES Produto(ProdutoId),
	CONSTRAINT FK_PedidoProduto_Pedido_PedidoId FOREIGN KEY (PedidoId) REFERENCES Pedido(PedidoId)
);
GO

CREATE TABLE StatusPagamento
(
	StatusPagamentoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeStatus VARCHAR(20)
);
GO

CREATE TABLE Pagamento
(
	PagamentoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Valor DECIMAL(10, 2),
	PedidoId UNIQUEIDENTIFIER NOT NULL,
	StatusPagamentoId UNIQUEIDENTIFIER NOT NULL,

	CONSTRAINT FK_Pagamento_Pedido_PedidoId FOREIGN KEY (PedidoId) REFERENCES Pedido(PedidoId),
	CONSTRAINT FK_Pagamento_StatusPagamento_StatusPagamentoId FOREIGN KEY (StatusPagamentoId) REFERENCES StatusPagamento(StatusPagamentoId),
);
GO

CREATE TABLE TipoALteracaoPagamento
(
	TipoAlteracaoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeTipo VARCHAR(20)
);
GO

CREATE TABLE LogPagamento
(
	LogPagamentoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	Valor DECIMAL(10, 2),
	PedidoId UNIQUEIDENTIFIER NOT NULL,
	StatusPagamentoId UNIQUEIDENTIFIER NOT NULL,
	TipoAlteracaoId UNIQUEIDENTIFIER NOT NULL,
	DataLog DATETIME2 DEFAULT GETDATE(),

	CONSTRAINT FK_LogPagamento_TipoAlteracaoPagamento_TipoAlteracaoId FOREIGN KEY (TipoAlteracaoId) REFERENCES TipoAlteracaoPagamento(TipoAlteracaoId),
	CONSTRAINT FK_LogPagamento_Pedido_PedidoId FOREIGN KEY (PedidoId) REFERENCES Pedido(PedidoId),
	CONSTRAINT FK_LogPagamento_StatusPagamento_StatusPagamentoId FOREIGN KEY (StatusPagamentoId) REFERENCES StatusPagamento(StatusPagamentoId),
);
GO

CREATE TABLE StatusEntrega
(
	StatusEntregaId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeStatus VARCHAR(20)
);
GO

CREATE TABLE Entrega
(
	EntregaId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	PedidoId UNIQUEIDENTIFIER NOT NULL,
	StatusEntregaId UNIQUEIDENTIFIER NOT NULL,

	CONSTRAINT FK_Entrega_Pedido_PedidoId FOREIGN KEY (PedidoId) REFERENCES Pedido(PedidoId),
	CONSTRAINT FK_Entrega_StatusEntrega_StatusEntregaId FOREIGN KEY (StatusEntregaId) REFERENCES StatusEntrega(StatusEntregaId),
);
GO

CREATE TABLE TipoALteracaoEntrega
(
	TipoAlteracaoId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	NomeTipo VARCHAR(20)
);
GO

CREATE TABLE LogEntrega
(
	LogEntregaId UNIQUEIDENTIFIER PRIMARY KEY DEFAULT NEWID(),
	EntregaId UNIQUEIDENTIFIER NOT NULL,
	PedidoId UNIQUEIDENTIFIER NOT NULL,
	TipoAlteracaoId UNIQUEIDENTIFIER NOT NULL,
	StatusEntregaId UNIQUEIDENTIFIER NOT NULL,

	CONSTRAINT FK_LogEntrega_TipoAlteracaoEntrega_TipoAlteracaoId FOREIGN KEY (TipoAlteracaoId) REFERENCES TipoAlteracaoEntrega(TipoAlteracaoId),
	CONSTRAINT FK_LogEntrega_Pedido_PedidoId FOREIGN KEY (PedidoId) REFERENCES Pedido(PedidoId),
	CONSTRAINT FK_LogEntrega_StatusEntrega_StatusEntregaId FOREIGN KEY (StatusEntregaId) REFERENCES StatusEntrega(StatusEntregaId),
)
