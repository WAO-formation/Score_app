import { useState } from 'react';
import { User, Mail, Phone, Lock, Eye, EyeOff, Save, Camera, Shield, Activity, LogOut } from 'lucide-react';
import { teamsData, officialsData, gamesData } from '../../config/constants';
import { useAuth } from '../../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { BRAND } from '../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const initialProfile = {
  name:  'Afanyu Emmanuel',
  email: 'admin@wao.com',
  phone: '+233 24 000 0000',
  role:  'Administrator',
  bio:   'WAO platform administrator. Manages games, teams, officials and reports.',
};

export default function Profile() {
  const { logout }          = useAuth();
  const navigate            = useNavigate();
  const [profile, setProfile]   = useState(initialProfile);
  const [editMode, setEditMode] = useState(false);
  const [form, setForm]         = useState(initialProfile);
  const [pwForm, setPwForm]     = useState({ current: '', next: '', confirm: '' });
  const [showPw, setShowPw]     = useState({ current: false, next: false, confirm: false });
  const [pwError, setPwError]   = useState('');
  const [savedMsg, setSavedMsg] = useState('');

  const initials = profile.name.trim().split(' ').map(n => n[0]).join('').toUpperCase().slice(0, 2);

  const handleSaveProfile = () => { setProfile(form); setEditMode(false); flash('Profile updated successfully.'); };

  const handleSavePassword = () => {
    if (!pwForm.current) return setPwError('Enter your current password.');
    if (pwForm.next.length < 6) return setPwError('New password must be at least 6 characters.');
    if (pwForm.next !== pwForm.confirm) return setPwError('Passwords do not match.');
    setPwError('');
    setPwForm({ current: '', next: '', confirm: '' });
    flash('Password changed successfully.');
  };

  const flash = (msg) => { setSavedMsg(msg); setTimeout(() => setSavedMsg(''), 3000); };
  const handleLogout = async () => { await logout(); navigate('/login', { replace: true }); };

  const stats = [
    { label: 'Total Teams',  value: teamsData.length,    color: 'bg-blue-50 text-blue-600' },
    { label: 'Total Games',  value: gamesData.length,    color: 'bg-red-50 text-[#c81434]' },
    { label: 'Officials',    value: officialsData.length, color: 'bg-green-50 text-green-600' },
  ];

  const inputCls = (active) =>
    `w-full pl-9 pr-4 py-2.5 border text-sm transition-colors ${
      active ? 'border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30' : 'border-gray-100 bg-gray-50 text-gray-600 cursor-default'
    }`;

  return (
    <section className="px-2 py-2 md:p-4 pb-12">
      {/* Page header */}
      <div className="flex items-center justify-between py-4 md:py-8">
        <h2 className="text-2xl md:text-3xl text-[#011B3B] uppercase tracking-widest" style={{ fontFamily: H }}>
          Profile
        </h2>
        <button
          onClick={handleLogout}
          className="flex items-center gap-2 px-4 py-2 text-sm font-semibold text-[#c81434] border border-[#c81434]/30 hover:bg-red-50 transition-colors"
          style={{ fontFamily: B }}
        >
          <LogOut className="w-4 h-4" /> Sign Out
        </button>
      </div>

      {savedMsg && (
        <div className="mb-4 px-4 py-3 bg-green-100 text-green-700 text-sm border border-green-200" style={{ fontFamily: B }}>
          {savedMsg}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">

        {/* Left */}
        <div className="space-y-5">
          {/* Avatar card */}
          <div className="bg-white border border-gray-100 p-6 flex flex-col items-center text-center">
            <div className="relative mb-4">
              <div className="w-24 h-24 bg-[#011B3B] flex items-center justify-center">
                <span className="text-white font-medium text-3xl" style={{ fontFamily: H }}>{initials}</span>
              </div>
              <button className="absolute bottom-0 right-0 w-8 h-8 bg-[#c81434] flex items-center justify-center hover:bg-[#e21e43] transition-colors">
                <Camera className="w-4 h-4 text-white" />
              </button>
            </div>
            <h3 className="text-lg text-[#011B3B]" style={{ fontFamily: H }}>{profile.name}</h3>
            <span className="text-xs bg-blue-100 text-blue-700 font-semibold px-3 py-1 mt-1" style={{ fontFamily: B }}>{profile.role}</span>
            <p className="text-sm text-gray-500 mt-3 leading-relaxed" style={{ fontFamily: B }}>{profile.bio}</p>
          </div>

          {/* Stats */}
          <div className="bg-white border border-gray-100 p-5">
            <h4 className="text-sm text-[#011B3B] mb-4 uppercase tracking-widest" style={{ fontFamily: B }}>Platform Overview</h4>
            <div className="space-y-3">
              {stats.map(({ label, value, color }) => (
                <div key={label} className={`flex items-center justify-between px-4 py-3 ${color.split(' ')[0]}`}>
                  <span className="text-sm text-gray-700" style={{ fontFamily: B }}>{label}</span>
                  <span className={`text-lg font-bold ${color.split(' ')[1]}`} style={{ fontFamily: H }}>{value}</span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Right */}
        <div className="lg:col-span-2 space-y-6">

          {/* Edit Profile */}
          <div className="bg-white border border-gray-100 p-6">
            <div className="flex items-center justify-between mb-6">
              <h4 className="text-[#011B3B] uppercase tracking-widest text-sm" style={{ fontFamily: B }}>Personal Information</h4>
              {!editMode ? (
                <button onClick={() => { setForm(profile); setEditMode(true); }} className="text-sm font-semibold text-[#c81434] hover:underline" style={{ fontFamily: B }}>Edit</button>
              ) : (
                <button onClick={() => setEditMode(false)} className="text-sm font-semibold text-gray-400 hover:underline" style={{ fontFamily: B }}>Cancel</button>
              )}
            </div>

            <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
              {[
                { label: 'Full Name', key: 'name',  icon: User,   type: 'text' },
                { label: 'Email',     key: 'email', icon: Mail,   type: 'email' },
                { label: 'Phone',     key: 'phone', icon: Phone,  type: 'text' },
                { label: 'Role',      key: 'role',  icon: Shield, type: 'text' },
              ].map(({ label, key, icon: Icon, type }) => (
                <div key={key}>
                  <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5" style={{ fontFamily: B }}>{label}</label>
                  <div className="relative">
                    <Icon className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <input
                      type={type}
                      value={editMode ? form[key] : profile[key]}
                      onChange={e => setForm({ ...form, [key]: e.target.value })}
                      disabled={!editMode || key === 'role'}
                      className={inputCls(editMode && key !== 'role')}
                      style={{ fontFamily: B }}
                    />
                  </div>
                </div>
              ))}

              <div className="sm:col-span-2">
                <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5" style={{ fontFamily: B }}>Bio</label>
                <textarea
                  rows={3}
                  value={editMode ? form.bio : profile.bio}
                  onChange={e => setForm({ ...form, bio: e.target.value })}
                  disabled={!editMode}
                  className={`w-full px-4 py-2.5 border text-sm resize-none transition-colors ${editMode ? 'border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30' : 'border-gray-100 bg-gray-50 text-gray-600 cursor-default'}`}
                  style={{ fontFamily: B }}
                />
              </div>
            </div>

            {editMode && (
              <button
                onClick={handleSaveProfile}
                className="mt-5 flex items-center gap-2 px-6 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] transition-all text-sm"
                style={{ fontFamily: B }}
              >
                <Save className="w-4 h-4" /> Save Changes
              </button>
            )}
          </div>

          {/* Change Password */}
          <div className="bg-white border border-gray-100 p-6">
            <div className="flex items-center gap-2 mb-6">
              <Lock className="w-4 h-4 text-[#011B3B]" />
              <h4 className="text-[#011B3B] uppercase tracking-widest text-sm" style={{ fontFamily: B }}>Change Password</h4>
            </div>

            {pwError && (
              <div className="mb-4 px-4 py-2.5 bg-red-50 text-red-600 text-sm border border-red-200" style={{ fontFamily: B }}>{pwError}</div>
            )}

            <div className="space-y-4">
              {[
                { label: 'Current Password', key: 'current' },
                { label: 'New Password',     key: 'next' },
                { label: 'Confirm Password', key: 'confirm' },
              ].map(({ label, key }) => (
                <div key={key}>
                  <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5" style={{ fontFamily: B }}>{label}</label>
                  <div className="relative">
                    <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <input
                      type={showPw[key] ? 'text' : 'password'}
                      value={pwForm[key]}
                      onChange={e => setPwForm({ ...pwForm, [key]: e.target.value })}
                      placeholder="••••••••"
                      className="w-full pl-9 pr-10 py-2.5 border border-gray-300 text-sm focus:outline-none focus:ring-2 focus:ring-[#c81434]/30"
                      style={{ fontFamily: B }}
                    />
                    <button type="button" onClick={() => setShowPw({ ...showPw, [key]: !showPw[key] })} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-gray-600">
                      {showPw[key] ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>
                </div>
              ))}
            </div>

            <button
              onClick={handleSavePassword}
              className="mt-5 flex items-center gap-2 px-6 py-2.5 bg-[#c81434] text-white font-semibold hover:bg-[#e21e43] transition-all text-sm"
              style={{ fontFamily: B }}
            >
              <Lock className="w-4 h-4" /> Update Password
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}
