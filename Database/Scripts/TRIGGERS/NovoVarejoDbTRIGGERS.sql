Use NovoVarejoDb
GO

---------------
-- TRIGGERS
---------------
--- LogUsuario criado

CREATE TRIGGER trg_UsuarioCriado
ON Usuario
AFTER INSERT
AS 
BEGIN
	INSERT INTO LogUsuario 
	(
		UsuarioId, StatusUsuarioId, CargoUsuarioId, EnderecoUsuarioId, NomeUsuario, Email, Senha, CPF, DataNascimento, 
		AlteracaoId
	) 
	SELECT
		i.UsuarioId,
		i.StatusUsuarioId,
		i.CargoUsuarioId,
		i.EnderecoUsuarioId,
		i.Nome,
		i.Email,
		i.CPF,
		i.DataNascimento
	FROM inserted i
	CROSS JOIN
		TipoALteracaoUsuario t
	WHERE t.NomeTipo = 'Usuario criado';
END;
GO


--- LogUsuario atualizado

CREATE TRIGGER trg_UsuarioAtualizado
ON Usuario
AFTER UPDATE
AS 
BEGIN
	INSERT INTO LogUsuario 
	(
		UsuarioId, StatusUsuarioId, CargoUsuarioId, EnderecoUsuarioId, NomeUsuario, Email, Senha, CPF, DataNascimento, 
		AlteracaoId
	) 
	SELECT
		i.UsuarioId,
		i.StatusUsuarioId,
		i.CargoUsuarioId,
		i.EnderecoUsuarioId,
		i.Nome,
		i.Email,
		i.CPF,
		i.DataNascimento
	FROM inserted i
	CROSS JOIN
		TipoALteracaoUsuario t
	WHERE t.NomeTipo = 'Usuario alterado';
END;
GO

--- LogUsuario deletado

CREATE TRIGGER trg_UsuarioDeletado
ON Usuario
INSTEAD OF DELETE
AS 
BEGIN
	UPDATE u
	SET u.StatusUsuarioId = s.StatusUsuarioId
	FROM Usuario u
	INNER JOIN deleted d
		ON u.UsuarioId = d.UsuarioId
	CROSS JOIN StatusUsuario s
	WHERE s.NomeStatus = 'inativo'
END;
GO
