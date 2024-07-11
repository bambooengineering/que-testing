require_relative "job_params"

module Que
  module Testing
    class ConnectionPool < Que::ConnectionPool
      def execute(command, params = [])
        return [] unless command == :insert_job

        job = JobParams.new(*params)
        klass = class_for(job.job_class)
        jobs[klass] << job
        params
      end

      def class_for(str)
        str.split('::').reduce(Object, &:const_get)
      end

      def jobs
        @jobs ||= Hash.new { |h,k| h[k] = [] }
      end
    end
  end
end
