# BMI Calculator

Aplicação desenvolvida em **Flutter** e **Dart** para calcular o **Índice de Massa Corporal (IMC)**, utilizando `StatefulWidget` para gerenciar o estado da tela.

O projeto foi criado como atividade prática com o objetivo de reproduzir uma calculadora de BMI/IMC, contendo campos de peso e altura, seleção de gênero, cálculo do resultado, classificação do IMC e exibição das categorias.

---

## Funcionalidades

* Interface com título **BMI Calculator**.
* Seleção de gênero: masculino ou feminino.
* Campo para informar o peso em kg.
* Campo para informar a altura em cm.
* Conversão automática da altura de centímetros para metros.
* Cálculo do IMC.
* Exibição do resultado com duas casas decimais.
* Classificação do IMC:

  * Menor que 18.5: abaixo do peso.
  * 18.5 a 24.9: normal.
  * 25 a 29.9: sobrepeso.
  * 30 ou mais: obesidade.
* Modal com as categorias do IMC.
* Validação para evitar:

  * Campos vazios.
  * Valores inválidos.
  * Valores menores ou iguais a zero.
  * Divisão por zero.
* Botão para limpar os campos e reiniciar o cálculo.

---

## Tecnologias utilizadas

* Flutter
* Dart
* Material Design

---

## Fórmula do IMC

A fórmula utilizada para calcular o IMC é:

```text
IMC = peso / (altura * altura)
```

Como a altura é informada em centímetros, ela é convertida para metros antes do cálculo.

Exemplo:

```text
Peso: 70 kg
Altura: 175 cm

Altura em metros = 175 / 100 = 1.75

IMC = 70 / (1.75 * 1.75)
IMC = 22.86
```

Classificação:

```text
22.86 = Normal
```

---

## Estrutura do projeto

```text
bmi_calculator/
├── lib/
│   └── main.dart
├── test/
├── pubspec.yaml
└── README.md
```

O arquivo principal da aplicação está em:

```text
lib/main.dart
```

---

## Como executar o projeto

Primeiro, clone o repositório:

```bash
git clone https://github.com/DouglasRodriguesBoeno/bmi_calculator.git
```

Entre na pasta do projeto:

```bash
cd bmi_calculator
```

Instale as dependências:

```bash
flutter pub get
```

Execute no navegador:

```bash
flutter run -d chrome
```

Ou execute em um emulador/dispositivo configurado:

```bash
flutter run
```

---

## Como validar o projeto

Para verificar se o projeto não possui problemas de análise, execute:

```bash
flutter analyze
```

Para rodar os testes, caso existam testes configurados:

```bash
flutter test
```

---

## Funcionamento da aplicação

A aplicação utiliza um `StatefulWidget` porque a tela precisa ser atualizada conforme o usuário interage com ela.

O usuário informa o peso e a altura. Ao clicar no botão **CALCULAR**, o sistema valida os campos, converte a altura de centímetros para metros, calcula o IMC e atualiza a interface com o resultado.

O método `setState()` é utilizado para atualizar os dados exibidos na tela, como o valor do IMC e sua classificação.

---

## Classificações do IMC

| IMC            | Classificação  |
| -------------- | -------------- |
| Menor que 18.5 | Abaixo do peso |
| 18.5 a 24.9    | Normal         |
| 25 a 29.9      | Sobrepeso      |
| 30 ou mais     | Obesidade      |

---

## Requisitos atendidos

* Uso de Flutter e Dart.
* Uso de `StatefulWidget`.
* Campos para peso em kg e altura em cm.
* Conversão da altura para metros.
* Cálculo correto do IMC.
* Exibição clara do resultado.
* Classificação do IMC.
* Tratamento de campos vazios e valores inválidos.
* Interface semelhante ao protótipo solicitado.
* Modal com categorias do IMC.
* Projeto versionado e publicado no GitHub.

---

## Autor

Desenvolvido por **Douglas Rodrigues**.