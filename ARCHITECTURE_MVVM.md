# Arquitetura MVVM - Projects Hub

## Visão Geral

Este projeto segue os princípios da arquitetura **MVVM (Model-View-ViewModel)** combinada com **Clean Architecture**, garantindo código limpo, testável e escalável seguindo as recomendações oficiais do Flutter.

## Princípios Arquiteturais

- **Separation of Concerns**: Cada camada tem uma responsabilidade específica
- **Dependency Inversion**: Dependências apontam para dentro (em direção à camada Domain)
- **Testability**: Fácil testar cada componente isoladamente
- **Scalability**: Fácil adicionar novas funcionalidades sem impactar as existentes
- **Maintainability**: Código organizado e fácil de manter
- **MVVM Pattern**: Separação clara entre View, ViewModel e Model

## Estrutura de Pastas

```
lib/
├── core/ # Componentes compartilhados
│   ├── base/ # Classes base
│   │   └── base_viewmodel.dart
│   ├── di/ # Injeção de dependência
│   │   └── injection_container.dart
│   ├── providers/ # Providers personalizados
│   │   └── viewmodel_provider.dart
│   └── constants/ # Constantes globais
├── features/ # Módulos de funcionalidades
│   ├── [feature_name]/
│   │   ├── data/ # Camada de dados
│   │   │   ├── datasources/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/ # Camada de domínio
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/ # Camada de apresentação
│   │       ├── viewmodels/ # ViewModels MVVM
│   │       ├── pages/ # Páginas/Views
│   │       └── widgets/ # Widgets específicos da feature
│   └── [other_features]/
├── shared/ # Componentes compartilhados entre features
│   ├── widgets/
│   └── services/
└── main.dart
```

## Camadas da Arquitetura

### 1. CORE

Contém componentes compartilhados em toda a aplicação:

- **base/**: Classes base como `BaseViewModel`
- **di/**: Container de injeção de dependência
- **providers/**: Providers personalizados para MVVM
- **constants/**: Constantes globais, URLs de API e configurações

### 2. FEATURES

Cada feature segue o padrão Clean Architecture com 3 camadas:

#### DATA Layer

Responsável pela recuperação e armazenamento de dados:

- **datasources/**: Fontes de dados (API, banco local)
- **models/**: Modelos de dados acoplados às fontes de dados
- **repositories/**: Implementação dos repositórios definidos na camada Domain

#### DOMAIN Layer

Contém a lógica de negócio central:

- **entities/**: Entidades de negócio puras
- **repositories/**: Contratos (interfaces) para os repositórios
- **usecases/**: Regras de negócio e lógica específicas

#### PRESENTATION Layer (MVVM)

Gerencia a interface do usuário e interação:

- **viewmodels/**: ViewModels que gerenciam o estado e lógica de apresentação
- **pages/**: Telas da aplicação (Views)
- **widgets/**: Componentes de UI específicos da feature

### 3. SHARED

Contém componentes reutilizáveis entre diferentes features:

- **widgets/**: Componentes de UI reutilizáveis
- **services/**: Serviços globais (navegação, armazenamento local)

## Padrão MVVM

### View (Páginas/Widgets)

- Responsável apenas pela apresentação
- Não contém lógica de negócio
- Usa `ViewModelConsumer` para observar mudanças no ViewModel
- Reage às mudanças de estado do ViewModel

### ViewModel

- Herda de `BaseViewModel`
- Gerencia o estado da UI
- Contém lógica de apresentação
- Comunica com Use Cases para operações de negócio
- Notifica a View sobre mudanças de estado

### Model (Entities/Use Cases)

- Representa os dados e regras de negócio
- Entities: Objetos de domínio puros
- Use Cases: Lógica de negócio específica

## Fluxo de Dados

```
View -> ViewModel -> UseCase -> Repository -> DataSource -> API/Database
```

1. A View dispara um evento para o ViewModel
2. O ViewModel chama o UseCase apropriado
3. O UseCase executa a lógica de negócio e interage com o Repository
4. O Repository determina qual DataSource usar (remoto ou local)
5. O DataSource busca os dados da API ou banco local
6. Os dados fluem de volta pelas camadas para atualizar a UI

## Tecnologias e Padrões

### Gerenciamento de Estado

- **Provider** com ViewModels personalizados
- **BaseViewModel** para funcionalidades comuns
- **ViewModelProvider** para injeção de dependência

### Injeção de Dependência

- **get_it** para localização de serviços
- **injectable** para geração automática de código

### Networking

- **http** para requisições HTTP
- **dio** (opcional) para requisições mais avançadas

### Serialização

- **json_annotation** e **json_serializable**
- **equatable** para comparação de objetos

### Armazenamento Local

- **shared_preferences** para armazenamento simples
- **hive** (opcional) para banco local

## Convenções de Nomenclatura

### Arquivos

- **snake_case** para nomes de arquivos

### Classes

- **PascalCase** para nomes de classes
- Nomes descritivos: `DiscountsTableViewModel`, `GetDiscountTableUseCase`

### Variáveis e Métodos

- **camelCase** para variáveis e métodos
- Nomes descritivos: `loadDiscountTable()`, `isLoading`

## Exemplo de Uso

### ViewModel

```dart
class DiscountsTableViewModel extends BaseViewModel {
  // Estado
  DiscountTableEntity? _discountTable;

  // Getters
  DiscountTableEntity? get discountTable => _discountTable;

  // Métodos
  Future<void> loadDiscountTable(String tableId) async {
    await executeWithLoading(() async {
      _discountTable = await _getDiscountTableUseCase(tableId);
    });
  }
}
```

### View

```dart
class DiscountsHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<DiscountsTableViewModel>(
      create: () => getIt<DiscountsTableViewModel>(),
      child: ViewModelConsumer<DiscountsTableViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return CircularProgressIndicator();
          }
          return YourWidget();
        },
      ),
    );
  }
}
```

## Vantagens da Arquitetura MVVM

1. **Separação Clara**: View, ViewModel e Model têm responsabilidades bem definidas
2. **Testabilidade**: ViewModels podem ser testados independentemente da UI
3. **Reutilização**: ViewModels podem ser reutilizados em diferentes Views
4. **Manutenibilidade**: Mudanças na UI não afetam a lógica de negócio
5. **Escalabilidade**: Fácil adicionar novas funcionalidades
6. **Padrão Oficial**: Segue as recomendações do Flutter para arquitetura
