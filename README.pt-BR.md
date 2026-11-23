# Lead-to-revenue — um data warehouse de funil de marketing com dados do GA4 no BigQuery

> Resumo executivo em português. A documentação técnica completa está em inglês: veja o [`README.md`](README.md)
> e a ordem de leitura no fim desta página.

Um warehouse de análise de marketing construído com a especificação primeiro: as perguntas de negócio vêm antes do SQL,
cada número aponta para a query que o produziu, e cada decisão fica registrada com as alternativas descartadas.

**A pergunta principal:** quais canais e campanhas trazem compradores, e não só leads, e quanto tempo eles levam para comprar?

---

## O que já está aqui, em números medidos

| | |
|---|---|
| Período | 2020-11-01 a 2021-01-31: 92 dias, sem nenhum dia faltando |
| Usuários | 270.154 (`user_pseudo_id` distintos) |
| Sessões | 360.129, ou 1,33 por usuário |
| Compradores | 4.419 usuários, 1,6% do total |
| Requisitos | 5 da fase atual (exploração), 1 comprovado. Os das próximas fases entram quando cada fase começar |

## Os três achados

1. **1,1% dos usuários nunca dispararam `session_start`.** São 3.038 usuários com outros eventos, mas sem o evento que marca
   o começo da visita. Por isso as sessões são contadas pela chave usuário + sessão, e não por esse evento.
2. **O passo de lista de produtos quase não foi registrado.** Só 44 usuários têm `view_item_list`, contra 13.180 em
   `select_item`. O funil de análise começa na página do produto.
3. **O GA4 não tem evento de lead.** Nenhum dos 17 eventos é cadastro ou login. A pergunta sobre leads que viram compradores
   precisa de uma tabela de CRM separada, sintética neste projeto.

## O método

- Perguntas de negócio escritas como decisões, antes de qualquer query ([north star](docs/00-north-star.md)).
- Requisitos numerados, cada um com um critério que pode ser conferido ([requisitos](specs/REQUIREMENTS.md)).
- Cada número do guia de dados tem um código (F01…) que leva à query, com os bytes processados.
- Decisões contestadas em ADRs, com o custo de voltar atrás; mudanças de plano no decision log.

## O que isto ainda não prova

- As camadas bronze, silver e gold ainda estão no papel.
- A definição de canal está em aberto.
- A tabela de leads, o dbt, o dashboard e o CI estão planejados, não construídos.

## Ordem de leitura

1. [docs/00-north-star.md](docs/00-north-star.md): as seis perguntas e as decisões que elas apoiam
2. [docs/data-context.md](docs/data-context.md): o dataset explicado para quem nunca viu GA4
3. [docs/architecture/dataset-findings.md](docs/architecture/dataset-findings.md): os achados que mudaram o plano
4. [specs/REQUIREMENTS.md](specs/REQUIREMENTS.md) e [specs/traceability.md](specs/traceability.md)
5. [docs/adr/](docs/adr/) e [docs/decision-log.md](docs/decision-log.md)
