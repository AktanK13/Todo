import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/features/edit_todo/bloc/edit_todo_bloc.dart';
import 'package:my_todo_app/hive/todos_api/models/todo_model.dart';
import 'package:my_todo_app/hive/todos_repository/todos_repository.dart';

class EditTodoPage extends StatelessWidget {
  const EditTodoPage({super.key});

  static Route<void> route({TodoModel? initialTodo}) {
    return MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => BlocProvider(
        create: (context) => EditTodoBloc(
          todosRepository: context.read<TodosRepository>(),
          initialTodo: initialTodo,
        ),
        child: const EditTodoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditTodoBloc, EditTodoState>(
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == EditTodoStatus.success,
      listener: (context, state) => Navigator.of(context).pop(),
      child: const EditTodoView(),
    );
  }
}

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
      (EditTodoBloc bloc) => bloc.state.isNewTodo,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isNewTodo ? "Add Todo" : "Edit Todo",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Save Changes",
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: () {
          if (status.isLoadingOrSuccess) {
            return;
          } else {
            if (formKey.currentState!.validate()) {
              context.read<EditTodoBloc>().add(const EditTodoSubmitted());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  duration: const Duration(milliseconds: 2500),
                  content: Text(
                    isNewTodo ? "Todo created" : "Todo edited",
                  ),
                ),
              );
            }
          }
        },
        child: status.isLoadingOrSuccess
            ? const CircularProgressIndicator.adaptive()
            : const Icon(Icons.check_rounded),
      ),
      body: SingleChildScrollView(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: const Column(
                children: [_TitleField(), _DescriptionField()],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.title ?? '';

    return TextFormField(
      key: const Key('editTodoView_title_textFormField'),
      initialValue: state.title,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Title",
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 108, 108, 108)),
      ),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      maxLength: 30,
      inputFormatters: [
        LengthLimitingTextInputFormatter(30),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoTitleChanged(value));
      },
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        labelText: "Description",
        hintText: hintText,
        hintStyle: const TextStyle(color: Color.fromARGB(255, 108, 108, 108)),
      ),
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      maxLength: 300,
      maxLines: 5,
      inputFormatters: [
        LengthLimitingTextInputFormatter(300),
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}
