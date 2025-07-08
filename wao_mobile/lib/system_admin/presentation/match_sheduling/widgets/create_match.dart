import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/shared/custom_text.dart';
import '../../../../shared/custom_buttons.dart';
import '../../../../shared/theme_data.dart';
import '../models/match_models.dart';


class CreateMatchForm extends StatefulWidget {
  final List<TeamModel> teams;
  final List<RefereeModel> referees;
  final List<JudgeModel> judges;
  final List<LocationModel> locations;
  final Function(MatchModel) onMatchCreated;

  const CreateMatchForm({
    Key? key,
    required this.teams,
    required this.referees,
    required this.judges,
    required this.locations,
    required this.onMatchCreated,
  }) : super(key: key);

  @override
  State<CreateMatchForm> createState() => _CreateMatchFormState();
}

class _CreateMatchFormState extends State<CreateMatchForm> {
  final _formKey = GlobalKey<FormState>();
  TeamModel? _team1;
  TeamModel? _team2;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  LocationModel? _selectedLocation;
  final List<RefereeModel> _selectedReferees = [];
  final List<JudgeModel> _selectedJudges = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set initial values if needed
    if (widget.teams.isNotEmpty) {
      _team1 = widget.teams[0];
    }
    if (widget.teams.length > 1) {
      _team2 = widget.teams[1];
    }
    if (widget.locations.isNotEmpty) {
      _selectedLocation = widget.locations[0];
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Select date method
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: lightColorScheme.secondary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  // Select time method
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay now = TimeOfDay.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: lightColorScheme.secondary,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        // Format time as "14:30"
        final hour = picked.hour.toString().padLeft(2, '0');
        final minute = picked.minute.toString().padLeft(2, '0');
        _timeController.text = '$hour:$minute';
      });
    }
  }

  // Toggle referee selection
  void _toggleReferee(RefereeModel referee) {
    setState(() {
      if (_selectedReferees.contains(referee)) {
        _selectedReferees.remove(referee);
      } else {
        // Maximum 2 referees
        if (_selectedReferees.length < 2) {
          _selectedReferees.add(referee);
        } else {
          // Replace the first referee if trying to add a third one
          _selectedReferees.removeAt(0);
          _selectedReferees.add(referee);

          // Show a notification
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Maximum 2 referees allowed. Replaced the first referee.', style:  AppStyles.informationText.copyWith(color: Colors.white),),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  // Toggle judge selection
  void _toggleJudge(JudgeModel judge) {
    setState(() {
      if (_selectedJudges.contains(judge)) {
        _selectedJudges.remove(judge);
      } else {
        // Maximum 6 judges
        if (_selectedJudges.length < 6) {
          _selectedJudges.add(judge);
        } else {
          // Show error notification
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('Maximum 6 judges allowed.', style:  AppStyles.informationText.copyWith(color: Colors.white),),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  // Submit form method
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Make sure all required fields are selected
      if (_team1 == null ||
          _team2 == null ||
          _selectedDate == null ||
          _selectedTime == null ||
          _selectedLocation == null ||
          _selectedReferees.isEmpty ||
          _selectedJudges.length < 6) {

        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(
            content: Text('Please fill all required fields.', style:  AppStyles.informationText.copyWith(color: Colors.white),),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create new match
      final newMatch = MatchModel(
        id: DateTime.now().millisecondsSinceEpoch, // Generate temporary ID
        date: _selectedDate!,
        time: _timeController.text,
        location: _selectedLocation!,
        team1: _team1!,
        team2: _team2!,
        referees: List.from(_selectedReferees),
        judges: List.from(_selectedJudges),
        status: MatchStatus.upcoming,
      );

      // Call the callback
      widget.onMatchCreated(newMatch);

      // Clear form
      setState(() {
        _selectedReferees.clear();
        _selectedJudges.clear();
        _dateController.clear();
        _timeController.clear();
        _selectedDate = null;
        _selectedTime = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teams section
           Text(
            'Teams',
            style:  AppStyles.informationText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Team selection
          Row(
            children: [
              // Team 1
              Expanded(
                child: _buildDropdownField<TeamModel>(
                  value: _team1,
                  items: widget.teams,
                  onChanged: (team) => setState(() => _team1 = team),
                  labelText: 'Team 1',
                  itemBuilder: (team) => Text(team.name),
                ),
              ),
              const SizedBox(width: 15),

              // VS label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'VS',
                  style: AppStyles.informationText.copyWith(
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // Team 2
              Expanded(
                child: _buildDropdownField<TeamModel>(
                  value: _team2,
                  items: widget.teams,
                  onChanged: (team) => setState(() => _team2 = team),
                  labelText: 'Team 2',
                  itemBuilder: (team) => Text(team.name),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // Date and Time section
           Text(
            'Date & Time',
            style:  AppStyles.informationText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Date and time selection
          Row(
            children: [
              // Date picker
              Expanded(
                child: TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                      color: lightColorScheme.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a date';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 15),

              // Time picker
              Expanded(
                child: TextFormField(
                  controller: _timeController,
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(
                      Icons.access_time,
                      color: lightColorScheme.secondary,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a time';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          /// Location section
           Text(
            'Location',
            style:  AppStyles.informationText.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),

          // Location dropdown
          _buildDropdownField<LocationModel>(
            value: _selectedLocation,
            items: widget.locations,
            onChanged: (location) => setState(() => _selectedLocation = location),
            labelText: 'Select Location',
            itemBuilder: (location) => Row(
              children: [
                Icon(
                  Icons.sports_basketball,
                  size: 16,
                  color: Colors.grey[700],
                ),
                const SizedBox(width: 8),
                Text(
                    location.name,
                    style: AppStyles.informationText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
              ],
            ),
          ),


          const SizedBox(height: 25),

          // Referees section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                'Referees',
                style:  AppStyles.informationText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_selectedReferees.length}/2 selected',
                style:  AppStyles.informationText.copyWith(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Referee selection
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.referees.length,
              itemBuilder: (context, index) {
                final referee = widget.referees[index];
                final isSelected = _selectedReferees.contains(referee);

                return GestureDetector(
                  onTap: () => _toggleReferee(referee),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? referee.color.withOpacity(0.2) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? referee.color : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: referee.color,
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
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
          const SizedBox(height: 25),

          // Judges section
          // Judges section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Judges',
                style: AppStyles.informationText.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_selectedJudges.length}/6 selected',
                style: AppStyles.informationText.copyWith(
                  color: _selectedJudges.length < 6 ? Colors.grey[600] : Colors.green[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.judges.length,
              itemBuilder: (context, index) {
                final judge = widget.judges[index];
                final isSelected = _selectedJudges.contains(judge);

                return GestureDetector(
                  onTap: () => _toggleJudge(judge),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? lightColorScheme.secondary.withOpacity(0.2) : Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: isSelected ? lightColorScheme.secondary : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: isSelected ? lightColorScheme.secondary : Colors.grey[400],
                          child: isSelected
                              ? const Icon(Icons.check, size: 14, color: Colors.white)
                              : const SizedBox(),
                        ),
                        const SizedBox(width: 8),
                        Text(judge.name),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 30),


          // Submit button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: SecondaryButtonWidget(label: 'Create Match', onTap: _submitForm, color: lightColorScheme.secondary,),
          ),
        ],
      ),
    );
  }

  // Helper method to build dropdown fields
  Widget _buildDropdownField<T>({
    required T? value,
    required List<T> items,
    required Function(T?) onChanged,
    required String labelText,
    required Widget Function(T) itemBuilder,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: itemBuilder(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}