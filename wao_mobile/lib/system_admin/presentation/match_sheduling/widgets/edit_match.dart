import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../shared/custom_appbar.dart';
import '../../../../shared/custom_text.dart';
import '../../../../shared/theme_data.dart';
import '../models/match_models.dart';


class EditMatchScreen extends StatefulWidget {
  final MatchModel match;
  const EditMatchScreen({
    Key? key,
    required this.match,
  }) : super(key: key);
  @override
  State<EditMatchScreen> createState() => _EditMatchScreenState();
}

class _EditMatchScreenState extends State<EditMatchScreen> {
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  late LocationModel _selectedLocation;
  late List<RefereeModel> _selectedReferees;
  late List<JudgeModel> _selectedJudges;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Initialize with existing match data
    _selectedDate = widget.match.date;
    _dateController.text = DateFormat('MMM dd, yyyy').format(_selectedDate);

    /// Parse time string
    final timeParts = widget.match.time.split(':');
    _selectedTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );
    _timeController.text = widget.match.time;

    _selectedLocation = widget.match.location;
    _selectedReferees = List.from(widget.match.referees);
    _selectedJudges = List.from(widget.match.judges);
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  /// Select date method (disabled, just for display)
  Future<void> _selectDate(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Date cannot be modified for scheduled matches'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Select time method (disabled, just for display)
  Future<void> _selectTime(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Time cannot be modified for scheduled matches'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  /// Toggle referee selection
  void _toggleReferee(RefereeModel referee) {
    setState(() {
      if (_selectedReferees.contains(referee)) {
        _selectedReferees.remove(referee);
      } else {
        /// Maximum 2 referees
        if (_selectedReferees.length < 2) {
          _selectedReferees.add(referee);
        } else {
          /// Replace the first referee if trying to add a third one
          _selectedReferees.removeAt(0);
          _selectedReferees.add(referee);

          /// Show a notification
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum 2 referees allowed. Replaced the first referee.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  /// Check if a referee is selected
  bool _isRefereeSelected(RefereeModel referee) {
    return _selectedReferees.any((r) => r.id == referee.id);
  }

  /// Toggle judge selection
  void _toggleJudge(JudgeModel judge) {
    setState(() {
      if (_selectedJudges.contains(judge)) {
        _selectedJudges.remove(judge);
      } else {
        if (_selectedJudges.length < 6) {
          _selectedJudges.add(judge);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Maximum 6 judges allowed.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  /// Check if a judge is selected
  bool _isJudgeSelected(JudgeModel judge) {
    return _selectedJudges.any((j) => j.id == judge.id);
  }

  /// Save changes method
  void _saveChanges() {
    /// Validate that we have required officials
    if (_selectedReferees.isEmpty || _selectedJudges.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least 1 referee and 6 judges'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    /// Update match with new officials
    widget.match.referees = List.from(_selectedReferees);
    widget.match.judges = List.from(_selectedJudges);

    /// Return to previous screen with success result
    Navigator.pop(context, true);

    /// Show success message (will appear on the previous screen)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Match updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Cancel match method
  void _cancelMatch() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text('Cancel Match'),
        content: const Text('Are you sure you want to cancel this match?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'No',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.match.status = MatchStatus.cancelled;
              Navigator.pop(context);
              Navigator.pop(context, true);

              /// Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Match cancelled successfully'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Yes, Cancel Match',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: 'Edit Games',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Match details card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Teams section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Team 1
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(widget.match.team1.logo),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.match.team1.name,
                            style:  AppStyles.informationText.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),

                      /// VS
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: lightColorScheme.secondary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            'VS',
                            style:  AppStyles.informationText.copyWith(
                              fontWeight: FontWeight.bold,
                              color: lightColorScheme.secondary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                      /// Team 2
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(widget.match.team2.logo),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.match.team2.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Divider(),
                  const SizedBox(height: 15),

                  /// Date and Time (read-only)
                  Row(
                    children: [
                      // Date field (read-only)
                      Expanded(
                        child: TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () => _selectDate(context),
                          decoration: InputDecoration(
                            labelText: 'Date',
                            enabled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      /// Time field (read-only)
                      Expanded(
                        child: TextFormField(
                          controller: _timeController,
                          readOnly: true,
                          onTap: () => _selectTime(context),
                          decoration: InputDecoration(
                            labelText: 'Time',
                            enabled: false,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            suffixIcon: Icon(
                              Icons.access_time,
                              color: Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  // Location (read-only)
                  TextFormField(
                    initialValue: '${widget.match.location.name} (${widget.match.location})',
                    readOnly: true,
                    enabled: false,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: Icon(
                         Icons.sports_basketball,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// Referees section
            _buildSectionHeader('Referees (Select 1-2)'),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedReferees.length}/2 selected',
                    style: TextStyle(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Referee selection
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: getReferees().length,
                      itemBuilder: (context, index) {
                        final referee = getReferees()[index];
                        final isSelected = _isRefereeSelected(referee);

                        return GestureDetector(
                          onTap: () => _toggleReferee(referee),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? referee.color.withOpacity(0.2)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected
                                    ? referee.color
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: referee.color,
                                  child: isSelected
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : const SizedBox(),
                                ),
                                const SizedBox(width: 8),
                                Text(referee.name),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Judges section

            _buildSectionHeader('Judges (Select 6)'),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedJudges.length}/6 selected',
                    style: AppStyles.informationText.copyWith(
                      color: _selectedJudges.length == 6 ? Colors.green[600] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 15),

                  /// Judge selection
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: getJudges().length,
                      itemBuilder: (context, index) {
                        final judge = getJudges()[index];
                        final isSelected = _isJudgeSelected(judge);

                        return GestureDetector(
                          onTap: () => _toggleJudge(judge),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? lightColorScheme.secondary.withOpacity(0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                color: isSelected
                                    ? lightColorScheme.secondary
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected)
                                  Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: lightColorScheme.secondary,
                                  ),
                                if (isSelected) const SizedBox(width: 5),
                                Text(judge.name),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),


            const SizedBox(height: 30.0,),


            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _cancelMatch,
                    icon: const Icon(Icons.cancel, color: Colors.white),
                    label:  Text(
                      'Cancel Match',
                      style:  AppStyles.informationText.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),


                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveChanges,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label:  Text(
                      'Save Changes',
                      style:  AppStyles.informationText.copyWith(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: lightColorScheme.secondary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Helper method to build section headers
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 10),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: lightColorScheme.secondary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style:  AppStyles.informationText.copyWith(
              color: Colors.grey[800],
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Get a list of all referees
  List<RefereeModel> getReferees() {
    return [
      RefereeModel(id: 1, name: 'John Smith', color: Colors.red),
      RefereeModel(id: 2, name: 'Sarah Lee', color: Colors.blue),
      RefereeModel(id: 3, name: 'Mike Brown', color: Colors.green),
      RefereeModel(id: 4, name: 'Lisa Wong', color: Colors.yellow),
    ];
  }

  /// Get a list of all judges
  List<JudgeModel> getJudges() {
    return [
      JudgeModel(id: 1, name: 'Judge One'),
      JudgeModel(id: 2, name: 'Judge Two'),
      JudgeModel(id: 3, name: 'Judge Three'),
      JudgeModel(id: 4, name: 'Judge Four'),
      JudgeModel(id: 5, name: 'Judge Five'),
      JudgeModel(id: 6, name: 'Judge Six'),
    ];
  }
}