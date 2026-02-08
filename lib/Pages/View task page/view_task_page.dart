import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/Models/task_model_class.dart';
import 'package:task_manager_project/Pages/update%20task%20page/update_task_page.dart';
import 'package:task_manager_project/widgets/see%20more%20&%20less%20description%20widget/see_more_less_description_widget.dart';
import 'package:task_manager_project/widgets/gradients_background_appbar_widget.dart';

class ViewTaskPage extends StatefulWidget {
  const ViewTaskPage({
    super.key,
    required this.tasks,
    required this.isViewCompletePage,
  });
  static const pageName = '/view_task_page';

  final Tasks tasks;
  final bool isViewCompletePage;
  @override
  State<ViewTaskPage> createState() => _ViewTaskPageState();
}

class _ViewTaskPageState extends State<ViewTaskPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<Offset> scale;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    scale = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset(0, 0),
    ).animate(controller);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(CupertinoIcons.back, color: Colors.white),
        ),
        title: Text(
          widget.tasks.title.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(color: Colors.white),
        ),
        flexibleSpace: FlexibleSpaceBar(
          background: const GradientsBackgroundAppbarWidget(),
          centerTitle: true,
        ),
        actions:
            (widget.isViewCompletePage == false)
                ? [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        UpdateTask.pageName,
                        arguments: widget.tasks,
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                  ),
                  SizedBox(width: 10),
                ]
                : const [],
      ),
      body: SlideTransition(
        position: scale,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: _buildInfoCard(
                  context,
                  label: 'Title',
                  child: Text(
                    widget.tasks.title.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: _buildInfoCard(
                  context,
                  label: 'Description',
                  child: DescriptionWithToggle(
                    description: widget.tasks.description.toString(),
                    id: widget.tasks.hashCode,
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: _buildInfoCard(
                  context,
                  label: 'Importance',

                  child: Text(
                    widget.tasks.importance.toString(),
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                child: _buildInfoCard(
                  context,
                  label: 'Due Date & Time',
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 20,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${widget.tasks.date} at ${widget.tasks.time}',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String label,
    required Widget child,
  }) {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0.3,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$label:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 400),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
