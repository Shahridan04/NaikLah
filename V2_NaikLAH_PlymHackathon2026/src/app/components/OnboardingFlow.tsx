import { useState } from 'react';
import { User, Building2, Shield, Check } from 'lucide-react';

interface OnboardingFlowProps {
  onComplete: (profile: any) => void;
}

export default function OnboardingFlow({ onComplete }: OnboardingFlowProps) {
  const [step, setStep] = useState(1);
  const [profile, setProfile] = useState({
    name: '',
    email: '',
    company: '',
    preferPinkBus: false,
    transportModes: [] as string[],
  });

  const handleNext = () => {
    if (step < 3) {
      setStep(step + 1);
    } else {
      onComplete(profile);
    }
  };

  const toggleTransportMode = (mode: string) => {
    if (profile.transportModes.includes(mode)) {
      setProfile({
        ...profile,
        transportModes: profile.transportModes.filter(m => m !== mode)
      });
    } else {
      setProfile({
        ...profile,
        transportModes: [...profile.transportModes, mode]
      });
    }
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-100 via-pink-100 to-blue-100 flex items-center justify-center px-4 py-12">
      <div className="bg-white rounded-2xl shadow-2xl max-w-2xl w-full p-8 md:p-12">
        {/* Progress Bar */}
        <div className="mb-8">
          <div className="flex justify-between mb-2">
            {[1, 2, 3].map((s) => (
              <div
                key={s}
                className={`w-full h-2 rounded-full mx-1 ${
                  s <= step ? 'bg-pink-600' : 'bg-gray-200'
                }`}
              />
            ))}
          </div>
          <p className="text-sm text-gray-600 text-center">Step {step} of 3</p>
        </div>

        {/* Step 1: Personal Information */}
        {step === 1 && (
          <div className="space-y-6">
            <div className="text-center mb-8">
              <div className="bg-pink-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <User className="w-8 h-8 text-pink-600" />
              </div>
              <h2 className="text-3xl font-bold text-gray-900 mb-2">Welcome!</h2>
              <p className="text-gray-600">Let's set up your profile</p>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Full Name
              </label>
              <input
                type="text"
                placeholder="e.g., Lisa Chen"
                value={profile.name}
                onChange={(e) => setProfile({ ...profile, name: e.target.value })}
                className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-pink-500 focus:outline-none"
              />
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Email Address
              </label>
              <input
                type="email"
                placeholder="lisa.chen@company.com"
                value={profile.email}
                onChange={(e) => setProfile({ ...profile, email: e.target.value })}
                className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-pink-500 focus:outline-none"
              />
            </div>

            <button
              onClick={handleNext}
              disabled={!profile.name || !profile.email}
              className="w-full bg-pink-600 text-white py-3 rounded-lg hover:bg-pink-700 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed font-semibold"
            >
              Continue
            </button>
          </div>
        )}

        {/* Step 2: Company & Pink Bus Preference */}
        {step === 2 && (
          <div className="space-y-6">
            <div className="text-center mb-8">
              <div className="bg-purple-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Building2 className="w-8 h-8 text-purple-600" />
              </div>
              <h2 className="text-3xl font-bold text-gray-900 mb-2">Company Details</h2>
              <p className="text-gray-600">Help us personalize your experience</p>
            </div>

            <div>
              <label className="block text-sm font-semibold text-gray-700 mb-2">
                Company / Organization
              </label>
              <select
                value={profile.company}
                onChange={(e) => setProfile({ ...profile, company: e.target.value })}
                className="w-full px-4 py-3 border-2 border-gray-300 rounded-lg focus:border-pink-500 focus:outline-none"
              >
                <option value="">Select your company</option>
                <option value="PKT Logistics">PKT Logistics</option>
                <option value="Tech Innovators Sdn Bhd">Tech Innovators Sdn Bhd</option>
                <option value="Green Energy Corp">Green Energy Corp</option>
                <option value="Urban Solutions">Urban Solutions</option>
                <option value="Other">Other</option>
              </select>
            </div>

            {/* Pink Bus Preference */}
            <div className="bg-pink-50 border-2 border-pink-200 rounded-xl p-6">
              <div className="flex items-start gap-4">
                <Shield className="w-8 h-8 text-pink-600 flex-shrink-0 mt-1" />
                <div className="flex-1">
                  <h3 className="text-xl font-bold text-gray-900 mb-2">
                    Women-Only Pink Bus Option
                  </h3>
                  <p className="text-gray-700 mb-4">
                    Safe, dedicated transport with female drivers, GPS tracking, and emergency SOS features. 
                    Perfect for night shifts and enhanced peace of mind.
                  </p>
                  <label className="flex items-center gap-3 cursor-pointer">
                    <input
                      type="checkbox"
                      checked={profile.preferPinkBus}
                      onChange={(e) => setProfile({ ...profile, preferPinkBus: e.target.checked })}
                      className="w-5 h-5 text-pink-600 border-gray-300 rounded focus:ring-pink-500"
                    />
                    <span className="font-semibold text-gray-900">
                      Yes, I prefer Pink Bus options
                    </span>
                  </label>
                </div>
              </div>
            </div>

            <div className="flex gap-3">
              <button
                onClick={() => setStep(1)}
                className="flex-1 bg-gray-200 text-gray-700 py-3 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
              >
                Back
              </button>
              <button
                onClick={handleNext}
                disabled={!profile.company}
                className="flex-1 bg-pink-600 text-white py-3 rounded-lg hover:bg-pink-700 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed font-semibold"
              >
                Continue
              </button>
            </div>
          </div>
        )}

        {/* Step 3: Transport Preferences */}
        {step === 3 && (
          <div className="space-y-6">
            <div className="text-center mb-8">
              <div className="bg-green-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                <Check className="w-8 h-8 text-green-600" />
              </div>
              <h2 className="text-3xl font-bold text-gray-900 mb-2">Transport Preferences</h2>
              <p className="text-gray-600">Which modes of transport do you use?</p>
            </div>

            <div className="grid grid-cols-2 gap-4">
              {[
                { id: 'bus', label: 'Bus', icon: '🚌' },
                { id: 'train', label: 'Train/LRT', icon: '🚆' },
                { id: 'bicycle', label: 'Bicycle', icon: '🚴' },
                { id: 'walking', label: 'Walking', icon: '🚶' },
                { id: 'carpool', label: 'Carpool', icon: '🚗' },
                { id: 'scooter', label: 'E-Scooter', icon: '🛴' },
              ].map((mode) => (
                <button
                  key={mode.id}
                  onClick={() => toggleTransportMode(mode.id)}
                  className={`p-4 rounded-xl border-2 transition-all ${
                    profile.transportModes.includes(mode.id)
                      ? 'border-pink-500 bg-pink-50'
                      : 'border-gray-300 bg-white hover:border-pink-300'
                  }`}
                >
                  <div className="text-4xl mb-2">{mode.icon}</div>
                  <div className="font-semibold text-gray-900">{mode.label}</div>
                  {profile.transportModes.includes(mode.id) && (
                    <Check className="w-5 h-5 text-pink-600 mx-auto mt-2" />
                  )}
                </button>
              ))}
            </div>

            <div className="bg-blue-50 border-2 border-blue-200 rounded-lg p-4">
              <p className="text-sm text-gray-700">
                💡 <strong>Tip:</strong> You'll earn different point amounts based on the environmental 
                impact of each transport mode. Walking and cycling earn the most!
              </p>
            </div>

            <div className="flex gap-3">
              <button
                onClick={() => setStep(2)}
                className="flex-1 bg-gray-200 text-gray-700 py-3 rounded-lg hover:bg-gray-300 transition-colors font-semibold"
              >
                Back
              </button>
              <button
                onClick={handleNext}
                disabled={profile.transportModes.length === 0}
                className="flex-1 bg-pink-600 text-white py-3 rounded-lg hover:bg-pink-700 transition-colors disabled:bg-gray-300 disabled:cursor-not-allowed font-semibold"
              >
                Get Started!
              </button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
}
