import { useState, useEffect } from "react";
import { Camera, CheckCircle, Scan, User, Shield } from "lucide-react";
import { useTheme } from "../contexts/ThemeContext";

interface ICVerificationPageProps {
  onVerificationComplete: () => void;
  userName: string;
}

export default function ICVerificationPage({
  onVerificationComplete,
  userName,
}: ICVerificationPageProps) {
  const { colors } = useTheme();
  const [step, setStep] = useState<"scan" | "facial" | "success">("scan");
  const [isScanning, setIsScanning] = useState(false);
  const [isFacialRecognitionAvailable, setIsFacialRecognitionAvailable] =
    useState(false);

  useEffect(() => {
    const checkFacialRecognition = () => {
      const isModernDevice =
        typeof navigator !== 'undefined' &&
        navigator.mediaDevices &&
        typeof navigator.mediaDevices.getUserMedia === 'function';
      setIsFacialRecognitionAvailable(isModernDevice);
    };

    checkFacialRecognition();
  }, []);

  const handleScanIC = () => {
    setIsScanning(true);

    setTimeout(() => {
      setIsScanning(false);
      if (isFacialRecognitionAvailable) {
        setStep("facial");
        setTimeout(() => {
          handleFacialRecognition();
        }, 500);
      } else {
        setStep("success");
        setTimeout(onVerificationComplete, 2000);
      }
    }, 2000);
  };

  const handleFacialRecognition = () => {
    setTimeout(() => {
      setStep("success");
      setTimeout(onVerificationComplete, 2000);
    }, 2500);
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-gray-50 via-white to-gray-100 flex items-center justify-center p-4">
      <div className="w-full max-w-md">
        {/* Header */}
        <div className="text-center mb-8">
          <div className={`inline-flex items-center justify-center w-16 h-16 ${colors.primary} rounded-2xl mb-4 shadow-lg`}>
            <Shield className="w-8 h-8 text-white" />
          </div>
          <h1 className="text-3xl font-bold text-gray-900 mb-2">
            Identity Verification
          </h1>
          <p className="text-gray-600">
            Verify your identity to secure your account
          </p>
        </div>

        {/* Verification Card */}
        <div className="bg-white rounded-2xl shadow-xl p-8 border border-gray-100">
          {step === "scan" && (
            <div className="text-center">
              <div className="mb-6">
                <div className={`inline-flex items-center justify-center w-24 h-24 ${colors.primaryLight} rounded-full mb-4`}>
                  <Scan className={`w-12 h-12 text-${colors.primary === 'bg-blue-600' ? 'blue' : colors.primary === 'bg-pink-600' ? 'pink' : 'gray'}-600`} />
                </div>
                <h2 className="text-xl font-bold text-gray-900 mb-2">
                  Scan Your IC
                </h2>
                <p className="text-gray-600 mb-6">
                  Place your Identity Card in front of the camera for scanning
                </p>
              </div>

              {/* Simulated Camera View */}
              <div className="relative mb-6 bg-gray-100 rounded-xl overflow-hidden aspect-[4/3] border-2 border-gray-200">
                <div className="absolute inset-0 flex items-center justify-center">
                  {isScanning ? (
                    <div className="relative">
                      <div className={`w-48 h-32 border-4 border-${colors.primary === 'bg-blue-600' ? 'blue' : colors.primary === 'bg-pink-600' ? 'pink' : 'gray'}-500 rounded-lg animate-pulse`}></div>
                      <div className="absolute inset-0 flex items-center justify-center">
                        <div className={`w-full h-1 bg-${colors.primary === 'bg-blue-600' ? 'blue' : colors.primary === 'bg-pink-600' ? 'pink' : 'gray'}-500 animate-pulse`}></div>
                      </div>
                    </div>
                  ) : (
                    <div className="text-center text-gray-400">
                      <Camera className="w-16 h-16 mx-auto mb-2" />
                      <p className="text-sm">Position your IC here</p>
                    </div>
                  )}
                </div>
              </div>

              <button
                onClick={handleScanIC}
                disabled={isScanning}
                className={`w-full ${colors.primary} ${colors.primaryHover} disabled:bg-gray-400 text-white py-3 rounded-xl font-medium transition-all shadow-lg hover:shadow-xl disabled:cursor-not-allowed transform hover:-translate-y-0.5 disabled:transform-none`}
              >
                {isScanning ? "Scanning..." : "Start Scanning"}
              </button>

              {isFacialRecognitionAvailable && (
                <p className="mt-4 text-sm text-gray-500">
                  Facial recognition will be activated automatically after IC
                  scan
                </p>
              )}
            </div>
          )}

          {step === "facial" && (
            <div className="text-center">
              <div className="mb-6">
                <div className="inline-flex items-center justify-center w-24 h-24 bg-blue-100 rounded-full mb-4">
                  <User className="w-12 h-12 text-blue-600" />
                </div>
                <h2 className="text-xl font-bold text-gray-900 mb-2">
                  Facial Recognition
                </h2>
                <p className="text-gray-600 mb-6">
                  Look at the camera and stay still
                </p>
              </div>

              {/* Simulated Camera View */}
              <div className="relative mb-6 bg-gray-100 rounded-xl overflow-hidden aspect-[4/3] border-2 border-gray-200">
                <div className="absolute inset-0 flex items-center justify-center">
                  <div className="relative">
                    <div className="w-48 h-48 border-4 border-blue-500 rounded-full animate-pulse"></div>
                    <div className="absolute inset-0 flex items-center justify-center">
                      <div className="w-32 h-32 border-4 border-blue-300 rounded-full animate-ping"></div>
                    </div>
                  </div>
                </div>
              </div>

              <div className="bg-blue-50 rounded-lg p-4 border border-blue-100">
                <p className="text-sm text-blue-800">
                  Processing facial recognition...
                </p>
              </div>
            </div>
          )}

          {step === "success" && (
            <div className="text-center">
              <div className="mb-6">
                <div className="inline-flex items-center justify-center w-24 h-24 bg-green-100 rounded-full mb-4">
                  <CheckCircle className="w-12 h-12 text-green-600" />
                </div>
                <h2 className="text-xl font-bold text-gray-900 mb-2">
                  Verification Successful
                </h2>
                <p className="text-gray-600 mb-6">
                  Welcome, {userName}! Your identity has been verified.
                </p>
              </div>

              <div className="bg-green-50 rounded-lg p-4 mb-6 border border-green-100 space-y-3">
                <div className="flex items-start space-x-3">
                  <CheckCircle className="w-5 h-5 text-green-600 mt-0.5 flex-shrink-0" />
                  <div className="text-left">
                    <p className="text-sm font-medium text-green-900">
                      IC Verified
                    </p>
                    <p className="text-xs text-green-700">
                      Identity card scanned successfully
                    </p>
                  </div>
                </div>
                {isFacialRecognitionAvailable && (
                  <div className="flex items-start space-x-3">
                    <CheckCircle className="w-5 h-5 text-green-600 mt-0.5 flex-shrink-0" />
                    <div className="text-left">
                      <p className="text-sm font-medium text-green-900">
                        Facial Recognition Complete
                      </p>
                      <p className="text-xs text-green-700">
                        Face match confirmed
                      </p>
                    </div>
                  </div>
                )}
              </div>

              <p className="text-sm text-gray-500">
                Redirecting to dashboard...
              </p>
            </div>
          )}
        </div>

        {/* Security Note */}
        <div className="mt-6 text-center text-xs text-gray-500">
          <p>Your biometric data is encrypted and stored securely</p>
        </div>
      </div>
    </div>
  );
}
